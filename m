Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1JYHO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:14:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50692 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab1JYHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:14:26 -0400
Date: Tue, 25 Oct 2011 09:14:18 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyle Manna <kyle.manna@fuel7.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2 1/6] mfd: TPS65910: Handle non-existent devices
Message-ID: <20111025071417.GE2919@opensource.wolfsonmicro.com>
References: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com>
 <1319475964-10841-2-git-send-email-kyle.manna@fuel7.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319475964-10841-2-git-send-email-kyle.manna@fuel7.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 12:05:59PM -0500, Kyle Manna wrote:
> Attempt to read the first register of the device, if there is no
> device return -ENODEV

Can you check for a known value in any of the registers?
