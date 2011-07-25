Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1GYBTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:19:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55913 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1GYBTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:19:08 -0400
Message-ID: <4E2CC489.1090509@codemonkey.ws>
Date: Sun, 24 Jul 2011 20:19:05 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
In-Reply-To: <alpine.DEB.2.00.1107242335580.18045@tiger>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2011 03:37 PM, Pekka Enberg wrote:
> Hi Linus,
>
> Please consider pulling from
>
> ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git
> kvm-tool-for-linus
>
> to merge the Native Linux KVM tool to Linux 3.1.
>
> [ The changes to 9p headers were already merged but show up in the pull
> request. ]
>
> The goal of this tool is to provide a clean, from-scratch, lightweight
> KVM host
> tool implementation that can boot Linux guest images with no BIOS
> dependencies
> and with only the minimal amount of legacy device emulation. The primary
> focus
> of the tool is to Linux but there are already people on working on
> supporting
> GRUB and other operating systems.

lguest already does this and lives in the kernel.

So purely from a kernel perspective, why have two tools in the tree that 
do the same thing?  Shouldn't you at least unify the userspace with the 
lguest userspace?

Regards,

Anthony Liguori
