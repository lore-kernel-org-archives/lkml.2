Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1DUPJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:09:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48440 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754439Ab1DUPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:09:21 -0400
Date: Thu, 21 Apr 2011 16:09:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv4 4/4] TPS65910: Add tps65910 regulator driver
Message-ID: <20110421150914.GA25526@opensource.wolfsonmicro.com>
References: <98522292-03FE-4B90-A37C-5C157E4CDDFB@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98522292-03FE-4B90-A37C-5C157E4CDDFB@slimlogic.co.uk>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 09:35:52AM -0500, Jorge Eduardo Candelaria wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> The regulator module consists of 3 DCDCs and 8 LDOs. The output
> voltages are configurable and are meant to supply power to the
> main processor and other components

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
