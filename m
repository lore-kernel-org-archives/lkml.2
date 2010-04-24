Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0DXJ1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 05:27:09 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48648 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0DXJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 05:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=mQKnAA4QMlAzJWV7my9mhIsE8DDXgaSnHc07sp+blz7xkktIAMvBYEzPWbXPFYGaTm
         JhkSsjqGKhW/TS2TwPn56sHXk96RF8o8rFyMON+R8a95qeU8zTzJnvR3SpHdSSZ9yyfB
         Agsz1jVLqLnsfJQLIWiFdGr16b28GH62xeqVw=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Date: Sat, 24 Apr 2010 10:27:00 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201004230806.13628.pedrogfrancisco@gmail.com> <20100423191342.GI29093@bicker>
In-Reply-To: <20100423191342.GI29093@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004241027.01241.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Sexta, 23 de Abril de 2010 20:13:42 Dan Carpenter escreveu:
> On Fri, Apr 23, 2010 at 08:06:13AM +0100, Pedro Francisco wrote:
-snip
> > 
> > Is it possible a faulty ath5k module to affect diverse parts of kernel
> > causing different oopses to happen referencing things as different as
> > cdrom_ioctl, find_vma, i915_gem_object_get_pages,
> > get_vfs_caps_from_disk,
> > warn_slowpath_common (ath5k_tasklet_rx), proc_lookup_de and
> > _spin_lock(ext4_getattr) [soft lookup]?
> 
-snip
> 
> If you know a working version of the kernel try a git bisect otherwise
> just post your dmesg with the crash etc.
> 

I don't. I doubt the dmesg will be of significance, as I said they're never the 
same.
However I've posted the dmesgs here [ 
http://ubuntuforums.org/showthread.php?t=1457568 ] prior to asking for help in 
LKML. Kernel version is Ubuntu's 2.6.32, not Vanilla.

I believe nothing significant can be extracted from them. Am I correct?

-- 
Pedro
