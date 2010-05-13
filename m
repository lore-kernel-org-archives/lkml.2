Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab0EMQKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:10:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49969 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab0EMQKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i/D/QwZ/CygBmp1DTFU9CWiqiDWJWrkrFA1eW1ljG+VhD6dXvfc205+c0QWHKpmw15
         fCoU/EZBgoj0VhwyY7158DLx7IG+qVeQ39OUFZLdF0Q3LGbiBgpdu6beHdMwkS5L/mfP
         X8CpnzYxiooP2VSCIep/l0qRUrIwgLA55I2og=
Date: Thu, 13 May 2010 09:02:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: mmotm 2010-05-11-18-20 uploaded
Message-ID: <20100513160249.GC22238@core.coreip.homeip.net>
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
 <6195.1273763194@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6195.1273763194@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:06:34AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 11 May 2010 18:21:22 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Dell Latitude E6500, x86_64 kernel.
> 
> Boots to single user prompt, but has issues on the way there.  Possibly
> very important - I was definitely *not* typing at the time (as I had hit
> return on the LUKS passphrase for the disk at 36 seconds after boot, and
> I didn't get the # prompt for single-user for another minute or two (probably
> due to udev having issues due to the oops). So I have no idea what it was
> trying to get a keycode for...
> 

Udev probably tries to remap special keys on your keyboard...

> [   40.717136] udev: starting version 154
> [   41.710153] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   41.711007] IP: [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
> [   41.711007] PGD 11d318067 PUD 118af1067 PMD 0
> [   41.711007] Oops: 0002 [#1] PREEMPT SMP
> [   41.711007] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4/idVendor
> [   41.711007] CPU 0
> [   41.711007] Modules linked in:
> [   41.711007]
> [   41.711007] Pid: 2501, comm: keymap Not tainted 2.6.34-rc7-mmotm0511 #2 0X564R/Latitude E6500
> 
> [   41.711007] RIP: 0010:[<ffffffff813bb996>]  [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b

I think this is Mauro's big keycode additions.

-- 
Dmitry
