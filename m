Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab0DADhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:37:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:57262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0DADhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:37:16 -0400
Message-ID: <4BB4148D.30102@kernel.org>
Date: Wed, 31 Mar 2010 20:35:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <95092268-54c9-4e22-8ccf-8f3f1eb266d0@email.android.com>
In-Reply-To: <95092268-54c9-4e22-8ccf-8f3f1eb266d0@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 08:16 PM, H. Peter Anvin wrote:
> OK... I think I'm going to write this up as unconfirmed... which means the only known problem that was not addressed in rc3 is the 32-bit NUMA issue, which we have a bug for.
> 
the 32 bit numa problem is one edge case (node0 doesn't have memory installed), 
and the problem has been there for a while before we introduce NO_BOOTMEM support.

Thanks

Yinghai
