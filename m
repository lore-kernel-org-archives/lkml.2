Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab1JGDOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:14:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53686 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759479Ab1JGDOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:14:03 -0400
References: <1317945508-19575-1-git-send-email-jistone@redhat.com> <990b8719-066b-4e1d-892f-6a3ea4241fb2@email.android.com> <m2d3e936fn.fsf@firstfloor.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <m2d3e936fn.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Make variable_test_bit reference all of *addr
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Thu, 06 Oct 2011 20:13:38 -0700
To: Andi Kleen <andi@firstfloor.org>
CC: Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Message-ID: <9d5b1868-51f5-4d88-8b0e-813e32b05a96@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory clobbers are universal producers, not consumers.

Andi Kleen <andi@firstfloor.org> wrote:

>"hpanvin@gmail.com" <hpa@zytor.com> writes:
>
>
>> This is concerning... the kernel relies heavily on asm volatile being
>a universal memory consumer.  If that is suddenly broken, we are f***
>in many, many, MANY places in the kernel all of a sudden!
>
>I don't think that's true. We generally add "memory" clobbers for this
>purpose. asm volatile just means "don't move" 
>
>Just this one doesn't have it for unknown reasons (someone
>overoptimizing?)
>
>-Andi
>
>-- 
>ak@linux.intel.com -- Speaking for myself only

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
