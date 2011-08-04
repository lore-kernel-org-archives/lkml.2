Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1HDLLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:11:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54534 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1HDLLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:11:02 -0400
Date: Thu, 4 Aug 2011 12:10:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/4] regulator: tps65023: patch updates
Message-ID: <20110804111058.GA12686@sirena.org.uk>
References: <marcus.folkesson@gmail.com>
 <1312282774-30880-1-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312282774-30880-1-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: While supplies last.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 12:59:30PM +0200, Marcus Folkesson wrote:
> This is version 2 of the tps65023 regulator patch set.
> 
> Changes from previous patches:
>  * Split up [PATCH 1/3] into two seperate patches ([PATCHv2 [1-2]/4])
>  * Declared tps_driver_data.info as const for avoiding awkward typecastings
>  * Removed table-length structs and uses tps->table_len instead. (As Axel Lin suggested in lkml)

As previously mentioned you need to send patches ot maintainers.
