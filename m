Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2AHAcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 19:32:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43621 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab2AHAcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 19:32:19 -0500
Subject: Re: [PATCH] KVM: fix mov immediate emulation for 64-bit operands
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <4F08AA3C.9090306@zytor.com>
Date: Sun, 8 Jan 2012 02:30:39 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <C814BCA3-145A-410F-8F4F-CE5617DDB1A2@gmail.com>
References: <1325967346-12539-1-git-send-email-namit@cs.technion.ac.il> <E0EE2EE9-96C1-4354-BDCE-19E3AF2C0F30@gmail.com> <4F08AA3C.9090306@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 7, 2012, at 10:25 PM, H. Peter Anvin wrote:

> On 01/07/2012 12:21 PM, Nadav Amit wrote:
>> MOV immediate instruction (opcodes 0xB8-0xBF) may take 64-bit operand.
>> The previous emulation implementation assumes the operand is no longer than 32.
>> 
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> 
> There are exactly two such instructions: MOV immediate (B8-BF) and MOV
> moff (A0-A3); you may want to check the latter too.
> 
> 	-hpa
> 

These instructions (A0-A3) seem to be already covered by the decode_abs function.

Regards,
Nadav