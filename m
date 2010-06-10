Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab0FJOnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:43:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34199 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab0FJOn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:43:29 -0400
Subject: Re: [PATCH 2/3] ARM: module - simplify unwind table handling
From: Catalin Marinas <catalin.marinas@arm.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1275567442-11370-3-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1275567442-11370-3-git-send-email-ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 10 Jun 2010 15:43:23 +0100
Message-ID: <1276181003.24535.46.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2010 14:43:23.0821 (UTC) FILETIME=[47433DD0:01CB08AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 13:17 +0100, Phil Carmody wrote:
> The various sections are all dealt with similarly, so factor out
> that common behaviour.
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin

