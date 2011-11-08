Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1KHRg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:36:56 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:34567 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676Ab1KHRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:36:54 -0500
From: Kevin Hilman <khilman@ti.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: cpuidle34xx.c: Fix compile error
Organization: Texas Instruments, Inc.
References: <1320768665-9759-1-git-send-email-joerg.roedel@amd.com>
Date: Tue, 08 Nov 2011 09:36:48 -0800
In-Reply-To: <1320768665-9759-1-git-send-email-joerg.roedel@amd.com> (Joerg
	Roedel's message of "Tue, 8 Nov 2011 17:11:05 +0100")
Message-ID: <87hb2eqzwv.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joerg.roedel@amd.com> writes:

> Add missing module.h include to provide THIS_MODULE.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

FYI...

Tony has already queued fix for this in his fixes branch.

     http://marc.info/?l=linux-arm-kernel&m=132071036621713&w=2

Kevin
