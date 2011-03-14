Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1CNTUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:20:19 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43060 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab1CNTUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:20:18 -0400
Date: Mon, 14 Mar 2011 13:20:12 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Denis Turischev <denis@compulab.co.il>,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 3/3 v2] sch_gpio: expand for Tunnel Creek
Message-ID: <20110314192012.GE16096@angua.secretlab.ca>
References: <4D7CE230.1070004@compulab.co.il>
 <4D7CE2BB.5010802@compulab.co.il>
 <4D7CE31E.207@compulab.co.il>
 <4D7DF391.50302@compulab.co.il>
 <20110314114540.GO31153@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314114540.GO31153@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 12:45:40PM +0100, Samuel Ortiz wrote:
> Hi Denis,
> 
> On Mon, Mar 14, 2011 at 12:53:05PM +0200, Denis Turischev wrote:
> > Almost the same driver for both Poulsbo and Tunnel Creek.
> > The difference is in quantity of GPIOs powered by the core power
> > rail and by suspend power supply, default values for some GPIOs, etc.
> > Detect actual hardware by platform device ID assigned in lpc_sch
> > and set configuration accordingly.
> Grant, are you ok with me taking this patch ?

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> 
> Cheers,
> Samuel.
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/
