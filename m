Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2FJLZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:25:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43328 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2FJLZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:25:31 -0400
Date: Sun, 10 Jun 2012 13:25:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sameer Nanda <snanda@chromium.org>
Cc: rob@landley.net, len.brown@intel.com, rjw@sisk.pl,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] power: add knob for printing device resume times
Message-ID: <20120610112540.GB9919@elf.ucw.cz>
References: <20120522202453.GA30723@kroah.com>
 <1337791532-15820-1-git-send-email-snanda@chromium.org>
 <CANMivWbRM+VvJaAHjz0Tr0SpqN3-OFp7DpXhtiDssJMNRX+5YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANMivWbRM+VvJaAHjz0Tr0SpqN3-OFp7DpXhtiDssJMNRX+5YA@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  #ifdef CONFIG_DEBUG_FS
> > @@ -411,6 +444,7 @@ static struct attribute * g[] = {
> >        &wakeup_count_attr.attr,
> >  #ifdef CONFIG_PM_DEBUG
> >        &pm_test_attr.attr,
> > +       &pm_print_times_attr.attr,
> >  #endif
> >  #endif
> >        NULL,
> > --
> > 1.7.7.3
> >
> 
> Greg KH, Rafael: any feedback on this patch?  Questions I can help
> answer to help push this along?

Yes; it should be possible to use something like module_parm() to make
this one-liner...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
