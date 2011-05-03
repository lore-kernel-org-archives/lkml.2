Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1ECJsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:48:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41022 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1ECJsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:48:31 -0400
Date: Tue, 3 May 2011 10:48:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH v2 0/2] regulator: msm: Add PM8921 regulator driver
Message-ID: <20110503094823.GB27833@sirena.org.uk>
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org> <1304118421-18764-1-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304118421-18764-1-git-send-email-collinsd@codeaurora.org>
X-Cookie: PIZZA!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 04:07:01PM -0700, David Collins wrote:
> This patch set adds a new regulator driver to control the regulators in
> Qualcomm PM8921 PMIC chips.  It also introduces board file changes to use
> this new driver with the Qualcomm MSM 8960 platform.

Please don't send patches as followups to old threads, this makes them
hard to find in mail archives.
