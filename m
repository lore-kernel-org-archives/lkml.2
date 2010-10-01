Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0JAT3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 15:29:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63022 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0JAT3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 15:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RLfuWKaOIXEHoyXhFD7Q5HSiKrqk2tUe3ImC8jNSQ6KYfVfFtM0UMh7rTJMUr8vfIA
         LTlGUuLmj2x64FmPT1BJ7Tmm2uXpqaYSW5VMJbsrMP069WbmU/JX721GhqXuz8NXWwAV
         H4LA0Tv6vRne8S0I0Kyu5hjQ2jmcdN5AUKPeU=
Subject: Re: [PATCH 15/18] mtd: Fix endianness issues from device tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>, Julia Lawall <julia@diku.dk>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Anatolij Gustschin <agust@denx.de>,
        Steve Deiters <SteveDeiters@basler.com>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1285916771-18033-16-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <1285916771-18033-16-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 22:29:06 +0300
Message-ID: <1285961346.32172.10.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 17:06 +1000, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This patch adds the appropriate conversions to correct the endianness
> issues in the MTD driver whenever it accesses the device tree (which is
> always big endian).
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

