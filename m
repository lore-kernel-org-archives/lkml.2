Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab1HIAxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 20:53:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55430 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1HIAxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 20:53:05 -0400
Date: Tue, 9 Aug 2011 01:52:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regulator: tps65023: Set missing bit for update
 core-voltage
Message-ID: <20110809005258.GA11006@sirena.org.uk>
References: <marcus.folkesson@gmail.com>
 <1312828175-11999-1-git-send-email-marcus.folkesson@gmail.com>
 <1312828175-11999-3-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312828175-11999-3-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: When the cup is full, carry it level.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 08:29:33PM +0200, Marcus Folkesson wrote:
> Setting the GO bit in CTRL2 for updating the core voltage
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
