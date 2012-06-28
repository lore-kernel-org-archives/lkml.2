Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab2F1KBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:01:52 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:37494 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab2F1KBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:01:51 -0400
Subject: Re: UEFI Secure boot using qemu-kvm
From: joeyli <jlee@suse.com>
To: JBottomley@Parallels.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jun 2012 18:01:08 +0800
Message-ID: <1340877668.6196.143.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James, 

On Wed, Jun 27, 2012 at 06:34:05PM +0100, James Bottomley wrote:

> The purpose of this email is to widen the pool of people who are playing
> with UEFI Secure boot.  The Linux Foundation Technical Advisory Board
> have been looking into this because it turns out to be rather difficult
> to lay your hands on real UEFI Secure Boot enabled hardware.
 

I am following your approach to reproduce your UEFI environment with
qemu-kvm. After run qemu-system-x86_64 the kvm launched and go to UEFI
shell success. So far so good!

But, I got a problem is the keyboard layout is not US keyboard, So I
need build a mapping table for reference when key-in any letter:

[		e
/		x
s		i
enter		t
down		enter
page up		down
...


Did you meet this issue on your side? 


Thanks a lot!
Joey Lee

