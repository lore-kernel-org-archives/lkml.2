Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab0FJOsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:48:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34786 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759188Ab0FJOsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:48:24 -0400
Subject: Re: [PATCH 3/3] ARM: module - additional unwind tables for
 exit/devexit sections
From: Catalin Marinas <catalin.marinas@arm.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1275567442-11370-4-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1275567442-11370-4-git-send-email-ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 10 Jun 2010 15:48:16 +0100
Message-ID: <1276181296.24535.51.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2010 14:48:16.0937 (UTC) FILETIME=[F5F93190:01CB08AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 13:17 +0100, Phil Carmody wrote:
> Without these, exit functions cannot be stack-traced, so to speak.
> This implies that module unloads that perform allocations (don't
> laugh) will cause noisy warnings on the console when kmemleak is
> enabled, as it presumes that all code's call chains are traceable.
> Similarly, BUGs and WARN_ONs will give additional console spam.
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin

