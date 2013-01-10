Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3AJJWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:22:01 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:37664 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3AJJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:21:58 -0500
Date: Thu, 10 Jan 2013 10:21:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: i2c-nforce2: fix coding style issues
Message-ID: <20130110102148.3260760e@endymion.delvare>
In-Reply-To: <CAH7P7NjdKsWjttmWyKxttm=rJDAErZxe7+Zf_oaSCx6Pmc1GWw@mail.gmail.com>
References: <1357764624-32134-1-git-send-email-laurent.navet@gmail.com>
	<20130110093255.5353fb31@endymion.delvare>
	<CAH7P7NjdKsWjttmWyKxttm=rJDAErZxe7+Zf_oaSCx6Pmc1GWw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013 09:52:36 +0100, Laurent Navet wrote:
> Hi Jean,
> 
> >
> > Unfortunately your patch also add one new checkpatch.pl warning:
> >
> > WARNING: line over 80 characters
> > #245: FILE: drivers/i2c/busses/i2c-nforce2.c:272:
> > +		data->word = inb_p(NVIDIA_SMB_DATA) | (inb_p(NVIDIA_SMB_DATA + 1) << 8);
> >
> > Please fix.
> >
> > As mentioned previously, __devinit has been dropped meanwhile, so this
> > change doesn't apply cleanly. Please rebase your patch on top of kernel
> > 3.8-rc3 (or Wolfram's i2c tree) so that Wolfram can apply it.
> >
> > All the rest looks very good now, thanks for the good work.
> 
> I've worked and tested against git.pengutronix.de wsa/linux.git
> ( http://git.pengutronix.de/?p=wsa/linux.git;a=summary )
> Isnt' it the right one ?

Only if you use branch i2c-embedded/for-next of that repository.
Otherwise you're lacking the patch which removed the __dev* markers.

Wolfram, it would be great if you could update your tree to avoid that
kind of issue.

-- 
Jean Delvare
