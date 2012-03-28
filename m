Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2C1L0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab2C1L0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:26:15 -0400
Message-ID: <4F72F549.6060407@redhat.com>
Date: Wed, 28 Mar 2012 13:26:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] kvm-intel: Auto-load on CPUs with VMX.
References: <20120321063350.GA3468@leaf>
In-Reply-To: <20120321063350.GA3468@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 08:33 AM, Josh Triplett wrote:
> Enable x86 feature-based autoloading for the kvm-intel module on CPUs
> with X86_FEATURE_VMX.
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

