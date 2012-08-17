Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab2HQDmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:42:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49511 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab2HQDmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:42:14 -0400
Date: Thu, 16 Aug 2012 20:42:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] PM / Sleep: introduce dpm_for_each_dev
Message-ID: <20120817034210.GA7770@kroah.com>
References: <1345167949-7419-1-git-send-email-ming.lei@canonical.com>
 <1345167949-7419-3-git-send-email-ming.lei@canonical.com>
 <CACVXFVNGHtXqiZtA0V6FuCEvebSs1F=jQG=nAYqwQjD6jdG2+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNGHtXqiZtA0V6FuCEvebSs1F=jQG=nAYqwQjD6jdG2+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 09:54:56AM +0800, Ming Lei wrote:
> On Fri, Aug 17, 2012 at 9:45 AM, Ming Lei <ming.lei@canonical.com> wrote:
> > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > index 44d1f23..bf86f89 100644
> > --- a/include/linux/pm.h
> > +++ b/include/linux/pm.h
> > @@ -640,6 +640,7 @@ extern void __suspend_report_result(const char *function, void *fn, int ret);
> >         } while (0)
> >
> >  extern int device_pm_wait_for_dev(struct device *sub, struct device *dev);
> > +extern void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *));
> >
> >  extern int pm_generic_prepare(struct device *dev);
> >  extern int pm_generic_suspend_late(struct device *dev);
> > @@ -679,6 +680,10 @@ static inline int device_pm_wait_for_dev(struct device *a, struct device *b)
> >         return 0;
> >  }
> >
> > +void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *))
> 
> Sorry, the above line is wrong, and should be defined as 'static inline'.
> Please drop this one and take the attachment patch.

Can you please just resend these, as this attachment was in base64 :(

