Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1KWQQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:16:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:57623 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1KWQQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:16:49 -0500
Subject: Re: [PATCH] powerpc/40x: Add APM8018X SOC support
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1322041464-20605-1-git-send-email-tinamdar@apm.com>
Date: Wed, 23 Nov 2011 10:16:47 -0600
Cc: jwboyer@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <24399FB8-956E-4C5A-B153-F77196602062@kernel.crashing.org>
References: <1322041464-20605-1-git-send-email-tinamdar@apm.com>
To: Tanmay Inamdar <tinamdar@apm.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 23, 2011, at 3:44 AM, Tanmay Inamdar wrote:

> arch/powerpc/kernel/udbg_16550.c            |   22 +

Would be probably good to split this change into its own patch.

- k
