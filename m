Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab0KPPAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:00:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1436 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0KPPAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:00:14 -0500
Subject: Re: [PATCH] checkpatch: Allow space before [ in the case of inline
 asm constraints
From: Joe Perches <joe@perches.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
In-Reply-To: <1289909596-7317-1-git-send-email-dave.martin@linaro.org>
References: <1289909596-7317-1-git-send-email-dave.martin@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 07:00:12 -0800
Message-ID: <1289919612.28741.58.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 12:13 +0000, Dave Martin wrote:
> This allows the customary syntax for declaring named arguments,
> such as:
> 
>     asm ("mov %[out],%[in]" : [out] "=r" (x) : [in] "r" (y));

Andy:

Maybe it'd be better to have a checkpatch pass that does
something similar to the c comment removal for asm blocks.

Maybe keyed on "\basm(\s+volatile){0,1}\s*" and strip
everything in the () block that follows it.


