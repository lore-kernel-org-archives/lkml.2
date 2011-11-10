Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1KJWrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:47:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40327 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1KJWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:47:08 -0500
Date: Thu, 10 Nov 2011 22:46:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 11/16] ARM: LPAE: Add fault handling support
Message-ID: <20111110224654.GV12913@n2100.arm.linux.org.uk>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com> <1320682618-1182-12-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320682618-1182-12-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:16:53PM +0000, Catalin Marinas wrote:
> The DFSR and IFSR register format is different when LPAE is enabled. In
> addition, DFSR and IFSR have similar definitions for the fault type.
> This modifies the fault code to correctly handle the new format.

I think this is also better than what we had.  Thanks for reworking
this.
