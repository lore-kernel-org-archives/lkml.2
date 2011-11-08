Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab1KHOmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:42:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab1KHOmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:42:01 -0500
Message-ID: <4EB93FA4.8020800@redhat.com>
Date: Tue, 08 Nov 2011 16:41:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
In-Reply-To: <1320543320-32728-1-git-send-email-agraf@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 03:35 AM, Alexander Graf wrote:
> To quickly get going, just execute the following as user:
>
>     $ ./Documentation/run-qemu.sh -r / -a init=/bin/bash
>
> This will drop you into a shell on your rootfs.
>

Doesn't work on Fedora 15.  F15's qemu-kvm doesn't have -machine or
-virtfs.  Even qemu.git on F15 won't build virtfs since xattr.h
detection is broken (patch posted).

-- 
error compiling committee.c: too many arguments to function

