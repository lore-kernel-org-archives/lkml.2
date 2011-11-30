Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1K3VDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:03:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:46536 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1K3VDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:03:31 -0500
Message-ID: <1322686997.29041.11.camel@pasglop>
Subject: Re: [PATCH v2] powerpc/40x: Add APM8018X SOC support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: jwboyer@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Dec 2011 08:03:17 +1100
In-Reply-To: <1322550101-28520-1-git-send-email-tinamdar@apm.com>
References: <1322550101-28520-1-git-send-email-tinamdar@apm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 12:31 +0530, Tanmay Inamdar wrote:
> The AppliedMicro APM8018X embedded processor targets embedded applications that
> require low power and a small footprint. It features a PowerPC 405 processor
> core built in a 65nm low-power CMOS process with a five-stage pipeline executing
> up to one instruction per cycle. The family has 128-kbytes of on-chip memory,
> a 128-bit local bus and on-chip DDR2 SDRAM controller with 16-bit interface.

Thanks, looks much better.

Cheers,
Ben.


