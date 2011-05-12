Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1ELHrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:47:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52611 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1ELHrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:47:46 -0400
Date: Thu, 12 May 2011 08:47:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Josh Wu <josh.wu@atmel.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org, lars.haring@atmel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        g.liakhovetski@gmx.de
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
	support
Message-ID: <20110512074725.GA1356@n2100.arm.linux.org.uk>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 03:42:18PM +0800, Josh Wu wrote:
> +err_alloc_isi:
> +	clk_disable(pclk);

clk_put() ?
