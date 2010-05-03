Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0ECTaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:30:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59236 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0ECTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:30:11 -0400
Date: Mon, 3 May 2010 15:22:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: NilsRadtkelkml@Think-Future.de
Cc: linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some accesspoint
 == hardlock
Message-ID: <20100503192219.GE25748@tuxdriver.com>
References: <20100503191756.GA3479@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503191756.GA3479@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 09:17:56PM +0200, NilsRadtkelkml@Think-Future.de wrote:

> Strangely, as stated in the previous message, this bug does only happen in conjunction at a specific 
> geographical position, so far it only happened there that is. How does this correlate with the designated
> code at line 2076 in iwl-agn-rs.c?:
> 
>   /* Sanity-check TPT calculations */
>   BUG_ON(window->average_tpt != ((window->success_ratio *
>       tbl->expected_tpt[index] + 64) / 128));

Interestingly enough, we have been discussing this line of code today.  Could you try the patch here?

	http://marc.info/?l=linux-wireless&m=127290931304496&w=2

Does it address the issue you are experiencing?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
