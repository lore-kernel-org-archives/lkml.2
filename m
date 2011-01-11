Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab1AKVOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:14:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55668 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1AKVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:14:34 -0500
Date: Tue, 11 Jan 2011 21:14:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/16] ARM: samsung: serial: don't treat NULL clk as an
	error
Message-ID: <20110111211422.GN11039@n2100.arm.linux.org.uk>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com> <1294749833-32019-9-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294749833-32019-9-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:43:45PM +0000, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
