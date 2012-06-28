Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab2F1KZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:25:27 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:38358 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2F1KZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:25:26 -0400
Subject: Re: Fwd: UEFI Secure boot using qemu-kvm
From: joeyli <jlee@suse.com>
To: JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAGLnvc-hLpUZaaOkeWMRtYefwL5goxuWP_99FyAzem7s_mncPg@mail.gmail.com>
References: <1340877668.6196.143.camel@linux-s257.site>
	 <CAGLnvc-hLpUZaaOkeWMRtYefwL5goxuWP_99FyAzem7s_mncPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jun 2012 18:24:51 +0800
Message-ID: <1340879091.6196.147.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James, 

於 四，2012-06-28 於 18:11 +0800，lee joey 提到：
> 
> 
> ---------- Forwarded message ----------
> From: joeyli <jlee@suse.com>
> Date: 2012/6/28
> Subject: Re: UEFI Secure boot using qemu-kvm
> To: JBottomley@parallels.com
> Cc: linux-kernel@vger.kernel.org
> 
> 
> Hi James,
> 
> On Wed, Jun 27, 2012 at 06:34:05PM +0100, James Bottomley wrote:
> 
> > The purpose of this email is to widen the pool of people who are
> playing
> > with UEFI Secure boot.  The Linux Foundation Technical Advisory
> Board
> > have been looking into this because it turns out to be rather
> difficult
> > to lay your hands on real UEFI Secure Boot enabled hardware.
> 
> 
> 
> I am following your approach to reproduce your UEFI environment with
> qemu-kvm. After run qemu-system-x86_64 the kvm launched and go to UEFI
> shell success. So far so good!
> 
> But, I got a problem is the keyboard layout is not US keyboard, So I
> need build a mapping table for reference when key-in any letter:
> 
> [               e
> /               x
> s               i
> enter           t
> down            enter
> page up         down
> ...
> 
> 
> Did you meet this issue on your side?
> 

I just found this issue only happen on when I used ssh connect to the
machine that setup environment then run qemu-kvm.

When direct launch qemu-kvm on the machine, there have no keyboard
layout problem. Not sure this problem is dependent to qemu or UEFI
image.


Thanks a lot!
Joey Lee


