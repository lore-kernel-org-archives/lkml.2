Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1DROzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:55:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58038 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab1DROzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:55:46 -0400
Message-ID: <4DAC5099.4010403@kernel.org>
Date: Mon, 18 Apr 2011 07:54:17 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 4/4] x86, gart: Make sure GART does not map physmem above
 1TB
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-5-git-send-email-joerg.roedel@amd.com> <4DAC4EC0.80008@zytor.com>
In-Reply-To: <4DAC4EC0.80008@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 07:46 AM, H. Peter Anvin wrote:
> On 04/18/2011 06:45 AM, Joerg Roedel wrote:
>> The GART can only map physical memory below 1TB. Make sure
>> the gart driver in the kernel does not try to map memory
>> above 1TB.
> 
> Where does this limit come from?

Nevermind... despite the generic name of the file it looks to be
specific to the K8 GART.

	-hpa

