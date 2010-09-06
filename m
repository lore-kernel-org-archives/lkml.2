Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0IFSsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:48:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab0IFSr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:47:58 -0400
Message-ID: <4C853747.9020401@redhat.com>
Date: Mon, 06 Sep 2010 21:47:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Andre Przywara <andre.przywara@amd.com>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: Fix allowed CPUID bits for KVM guests
References: <1283778860-26843-1-git-send-email-andre.przywara@amd.com> <1283778860-26843-4-git-send-email-andre.przywara@amd.com>
In-Reply-To: <1283778860-26843-4-git-send-email-andre.przywara@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 04:14 PM, Andre Przywara wrote:
> The AMD extensions to AVX (FMA4, XOP) work on the same YMM register set
> as AVX, so they are safe for guests to use, as long as AVX itself
> is allowed. Add F16C and AES on the way for the same reasons.

Acked-by: Avi Kivity <avi@redhat.com>

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

