Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab2F1KWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:22:48 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34454 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865Ab2F1KWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:22:47 -0400
References: <1340877668.6196.143.camel@linux-s257.site>
User-Agent: K-9 Mail for Android
In-Reply-To: <1340877668.6196.143.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Subject: Re: UEFI Secure boot using qemu-kvm
From: James Bottomley <James.Bottomley@parallels.com>
Date: Thu, 28 Jun 2012 11:22:04 +0100
To: joeyli <jlee@suse.com>, <JBottomley@parallels.com>
CC: <linux-kernel@vger.kernel.org>
Message-ID: <d9f6fbce-f07a-4347-bce5-8fb20971944b@email.android.com>
X-Originating-IP: [178.101.12.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



joeyli <jlee@suse.com> wrote:

>Hi James, 
>
>On Wed, Jun 27, 2012 at 06:34:05PM +0100, James Bottomley wrote:
>
>> The purpose of this email is to widen the pool of people who are
>playing
>> with UEFI Secure boot.  The Linux Foundation Technical Advisory Board
>> have been looking into this because it turns out to be rather
>difficult
>> to lay your hands on real UEFI Secure Boot enabled hardware.
> 
>
>I am following your approach to reproduce your UEFI environment with
>qemu-kvm. After run qemu-system-x86_64 the kvm launched and go to UEFI
>shell success. So far so good!
>
>But, I got a problem is the keyboard layout is not US keyboard, So I
>need build a mapping table for reference when key-in any letter:
>
>[		e
>/		x
>s		i
>enter		t
>down		enter
>page up		down
>...
>
>
>Did you meet this issue on your side? 

Well no. I've got a US keyboard. You probably need the keymap directory from qemu-kvm. 

The best thing is probably to copy all the qemu files to a new directory and then copy in the qemu-ovmf ones (assuming standard qemu-kvm works for you).

James
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
