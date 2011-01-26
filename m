Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1AZK4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:56:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:45199 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab1AZK4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:56:49 -0500
Date: Wed, 26 Jan 2011 18:15:56 +0800
From: Greg KH <gregkh@suse.de>
To: Bob Liu <lliubbo@gmail.com>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] firmware_classs: change val uevent's type to bool
Message-ID: <20110126101556.GA16446@suse.de>
References: <1296036004-15644-1-git-send-email-lliubbo@gmail.com>
 <C5C86A19469DAE48AAAD0E5F3716E44501D6329793@irsmsx504.ger.corp.intel.com>
 <AANLkTinzHZorkTpDSv5J9_Q5kO5UUFnZb3CAafyOu2Qe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinzHZorkTpDSv5J9_Q5kO5UUFnZb3CAafyOu2Qe@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 06:03:32PM +0800, Bob Liu wrote:
> On Wed, Jan 26, 2011 at 5:56 PM, Berg, Johannes <johannes.berg@intel.com> wrote:
> > @@ -463,7 +463,8 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
> >        f_dev->parent = device;
> >        f_dev->class = &firmware_class;
> >
> > -       dev_set_uevent_suppress(f_dev, true);
> > +       if (uevent)
> > +               dev_set_uevent_suppress(f_dev, true);
> >
> > Everything but this is a no-op basically, but you didn't even describe this change?
> >
> 
> 
> Hmm.. Sorry for that, but I mentioned that by "fix a place missing
> uevent check".
> I added this check because I think it should be paired with following
> dev_set_uevent_suppress(f_dev, false).

That's fine, but please, split that out into a separate patch.

Remember, a patch should only do one thing.

Please resend this as two patches and I will be glad to queue it up.

thanks,

greg k-h
