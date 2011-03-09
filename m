Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab1CIQoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:44:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1CIQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:44:42 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=Qq7vIXD-ciIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=b8VgSBC0AAAA:8 a=xW7rBovET4Y6dF-fHFYA:9 a=DM7K0KiaRN4KRdfrWsuk29oiB3AA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95
From: Steven Rostedt <rostedt@goodmis.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <gregkh@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org
In-Reply-To: <s5hfwqwnt9s.wl%tiwai@suse.de>
References: <1299685189.15854.182.camel@gandalf.stny.rr.com>
	 <20110309155309.GA30598@suse.de>
	 <1299687658.15854.227.camel@gandalf.stny.rr.com>
	 <s5hfwqwnt9s.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 11:44:39 -0500
Message-ID: <1299689079.15854.251.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 17:38 +0100, Takashi Iwai wrote:
> At Wed, 09 Mar 2011 11:20:58 -0500,
> Steven Rostedt wrote:
> > 
> > On Wed, 2011-03-09 at 07:53 -0800, Greg KH wrote:
> > 
> > > > This was for a 386 build. I could give a .config and full dmesg if
> > > > needed.
> > > 
> > > I think the sound developers (now on CC: would probably like to see
> > > that.)
> > 
> > http://rostedt.homelinux.com/private/mitest-boot-randconfig-fail-20110209042837/config
> > 
> > http://rostedt.homelinux.com/private/mitest-boot-randconfig-fail-20110209042837/dmesg
> 
> Could you try the patch below?  Totally untested.
> 

Will do, but first I'll make sure that this is reproducible on every
boot.

Thanks,

-- Steve


