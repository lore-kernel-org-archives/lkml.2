Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2F1Kud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:50:33 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:50156 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2F1Kuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:50:32 -0400
Subject: Re: UEFI Secure boot using qemu-kvm
From: joeyli <jlee@suse.com>
To: James Bottomley <James.Bottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d9f6fbce-f07a-4347-bce5-8fb20971944b@email.android.com>
References: <1340877668.6196.143.camel@linux-s257.site>
	 <d9f6fbce-f07a-4347-bce5-8fb20971944b@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jun 2012 18:49:57 +0800
Message-ID: <1340880597.6196.158.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2012-06-28 於 11:22 +0100，James Bottomley 提到：
> 
> joeyli <jlee@suse.com> wrote:
> 
> >Hi James, 
> >
> >On Wed, Jun 27, 2012 at 06:34:05PM +0100, James Bottomley wrote:
> >
> >> The purpose of this email is to widen the pool of people who are
> >playing
> >> with UEFI Secure boot.  The Linux Foundation Technical Advisory Board
> >> have been looking into this because it turns out to be rather
> >difficult
> >> to lay your hands on real UEFI Secure Boot enabled hardware.
> > 
> >
> >I am following your approach to reproduce your UEFI environment with
> >qemu-kvm. After run qemu-system-x86_64 the kvm launched and go to UEFI
> >shell success. So far so good!
> >
> >But, I got a problem is the keyboard layout is not US keyboard, So I
> >need build a mapping table for reference when key-in any letter:
> >
> >[		e
> >/		x
> >s		i
> >enter		t
> >down		enter
> >page up		down
> >...
> >
> >
> >Did you meet this issue on your side? 
> 
> Well no. I've got a US keyboard. You probably need the keymap directory from qemu-kvm. 
> 
> The best thing is probably to copy all the qemu files to a new directory and then copy in the qemu-ovmf ones (assuming standard qemu-kvm works for you).
> 
> James

Yes, I just found the problem happen on using SSH login to the machine
that have qemu-kvm and launch it with UEFI shell.
If I direct launch kvm on the machine, everything is OK!

I already import your PK.cer and KEK.cer and run
HelloWorld.efi/HelloWorld-signed.efi to verify the secure boot success.

When running non-signed file, shell show up:
	Error reported: Access Denied

Thanks a lot for your document and RPMs on OBS, it's really useful to me
for verify secure boot.


Regards
Joey Lee 


