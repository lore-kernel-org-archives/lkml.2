Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0KJPsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:48:07 -0500
Received: from 8bytes.org ([88.198.83.132]:56266 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab0KJPsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:48:06 -0500
Date: Wed, 10 Nov 2010 16:48:04 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] arch/x86/kernel/pci-iommu_table.c: Convert
	sprintf_symbol to %pS
Message-ID: <20101110154803.GB5193@8bytes.org>
References: <1288998760-11775-1-git-send-email-joe@perches.com> <1288998760-11775-3-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288998760-11775-3-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 04:12:35PM -0700, Joe Perches wrote:
> Coalesce format as well.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

