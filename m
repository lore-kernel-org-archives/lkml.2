Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2AGUZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 15:25:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34796 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2AGUZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 15:25:40 -0500
Message-ID: <4F08AA3C.9090306@zytor.com>
Date: Sat, 07 Jan 2012 12:25:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix mov immediate emulation for 64-bit operands
References: <1325967346-12539-1-git-send-email-namit@cs.technion.ac.il> <E0EE2EE9-96C1-4354-BDCE-19E3AF2C0F30@gmail.com>
In-Reply-To: <E0EE2EE9-96C1-4354-BDCE-19E3AF2C0F30@gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2012 12:21 PM, Nadav Amit wrote:
> MOV immediate instruction (opcodes 0xB8-0xBF) may take 64-bit operand.
> The previous emulation implementation assumes the operand is no longer than 32.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>

There are exactly two such instructions: MOV immediate (B8-BF) and MOV
moff (A0-A3); you may want to check the latter too.

	-hpa

