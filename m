Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2AMNCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:02:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44141 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2AMNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:02:53 -0500
Date: Fri, 13 Jan 2012 13:02:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mans Rullgard <mans.rullgard@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Jassi Brar <jaswinder.singh@linaro.org>,
        Javi Merino <javi.merino@arm.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: pl330: fix null pointer dereference in
	pl330_chan_ctrl()
Message-ID: <20120113130222.GU1068@n2100.arm.linux.org.uk>
References: <1326458191-23492-1-git-send-email-mans.rullgard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326458191-23492-1-git-send-email-mans.rullgard@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:36:31PM +0000, Mans Rullgard wrote:
> This fixes the thrd->req_running field being accessed before thrd
> is checked for null.  The error was introduced in abb959f.
> 
> Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>

I don't know what's happening with the PL330 driver, but there's patches
around to remove this file and merge it with the DMA engine driver.
