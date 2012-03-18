Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2CRVlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 17:41:18 -0400
Received: from cet.com.ru ([195.178.208.66]:52107 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755548Ab2CRVlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 17:41:16 -0400
Date: Mon, 19 Mar 2012 01:41:15 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] w1: Disable irqs during 1-wire bus operations,
 extend 1-wire reset pulse
Message-ID: <20120318214115.GB20521@ioremap.net>
References: <4F63AFD5.40605@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F63AFD5.40605@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 10:25:41PM +0100, Markus Franke (markus.franke@s2002.tu-chemnitz.de) wrote:
> This patch offers the possibility to disables irqs during w1_write_bit() and w1_reset_bus() operations as timing requirements are very strict for the 1-wire bus protocol. Per default interrupts are enabled but can be disabled via the module parameter "w1_disable_irqs".
> 
> Extend 1-wire reset pulse length from 480us to 500us as 480us is the minimum requirement for the 1-wire reset/presence pulse.
> 
> It applies to the current linux kernel git tree.
> 
> Signed-off-by: Markus Franke <franm@hrz.tu-chemnitz.de>

Patch looks good, thank you
Greg, please apply

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
