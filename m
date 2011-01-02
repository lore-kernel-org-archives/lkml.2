Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1ABXk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 18:40:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab1ABXk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 18:40:28 -0500
Message-ID: <4D210CCC.7050509@redhat.com>
Date: Sun, 02 Jan 2011 18:39:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Sedat Dilek <sedat.dilek@googlemail.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        mtosatti@redhat.com, gleb@redhat.com, avi@redhat.com,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] kvm: Fix section mismatch derived from kvm_guest_cpu_online()
References: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
In-Reply-To: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2011 06:01 PM, Sedat Dilek wrote:
>  From my build.log:
>
> WARNING: arch/x86/built-in.o(.text+0x1bb74): Section mismatch in reference from the function kvm_guest_cpu_online() to the function .cpuinit.text:kvm_guest_cpu_init()
> The function kvm_guest_cpu_online() references
> the function __cpuinit kvm_guest_cpu_init().
> This is often because kvm_guest_cpu_online lacks a __cpuinit
> annotation or the annotation of kvm_guest_cpu_init is wrong.
>
> This patch fixes the warning.
>
> Tested with linux-next (next-20101231)
>
> Signed-off-by: Sedat Dilek<sedat.dilek@gmail.com>

ACK

-- 
All rights reversed
