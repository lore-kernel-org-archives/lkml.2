Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2DRUtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:49:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42046 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2DRUtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:49:23 -0400
Message-ID: <4F8F28BF.6010003@zytor.com>
Date: Wed, 18 Apr 2012 13:49:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org, rjw@sisk.pl, "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 2/2] x86/acpi: Call acpi_enter_sleep_state via an asmlinkage
 C function from assembler.
References: <1334769518-7660-1-git-send-email-konrad.wilk@oracle.com> <1334769518-7660-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1334769518-7660-3-git-send-email-konrad.wilk@oracle.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 10:18 AM, Konrad Rzeszutek Wilk wrote:
> 
> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> [v2: Remove extra assembler operations, per hpa review]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: H. Peter Anvin <hpa@zytor.com>

Len, your tree or mine?

	-hpa

