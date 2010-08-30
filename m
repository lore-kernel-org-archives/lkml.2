Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0H3LZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:25:18 -0400
Received: from freeflow.nu ([178.79.134.28]:54887 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab0H3LZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:25:17 -0400
Message-ID: <4C7B951B.3060007@kernel.org>
Date: Mon, 30 Aug 2010 14:25:15 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] x86: Remove unnecessary ifdefs from i387 code.
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>	<1283011478-27237-11-git-send-email-brgerst@gmail.com>	<AANLkTinnhht86aKkmHKypmgmThJP8a1rGEXFkwyW7dc3@mail.gmail.com>	<AANLkTik7Gv3xoZphR0VRkHdr3Z1tvO484S-zkYncC2K7@mail.gmail.com>	<4C7B454A.7050101@kernel.org> <AANLkTimO4xHJ5AwZNjctYRDU6jqrY6mkVfkaG1u_LnTx@mail.gmail.com>
In-Reply-To: <AANLkTimO4xHJ5AwZNjctYRDU6jqrY6mkVfkaG1u_LnTx@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 8/30/10 2:21 PM, Brian Gerst wrote:
> FXSR is a required feature on 64-bit, therefore cpu_has_fxsr is always
>>> true.
>> Yes, I realize that but it will still read boot_cpu_data at runtime, no?
> Look at cpu_has().  It checks REQUIRED_MASK* if the feature bit is a
> constant, and returns true without testing the actual bit in
> boot_cpu_data for required features.
Right you are, thanks for the explanation!
