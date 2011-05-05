Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1EEIc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:32:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54273 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752925Ab1EEIc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:32:26 -0400
Date: Thu, 5 May 2011 09:31:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
Subject: Re: [PATCHv2 2/5] regulator: tps65911: Add new chip version
Message-ID: <20110505083144.GI11744@opensource.wolfsonmicro.com>
References: <98A43D4D-2C9B-41D2-BCE1-51CA110CDEFE@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98A43D4D-2C9B-41D2-BCE1-51CA110CDEFE@slimlogic.co.uk>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 07:21:27PM -0500, Jorge Eduardo Candelaria wrote:
> The tps65911 chip introduces new features, including changes in
> the regulator module.
> 
> - VDD1 and VDD2 remain unchanged.
> - VDD3 is now named VDDCTRL and has a wider voltage range.
> - LDOs are now named LDO1...8 and voltage ranges are sequential,
>   making LDOs easier to handle.
> 
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
