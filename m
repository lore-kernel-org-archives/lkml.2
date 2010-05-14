Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab0ENRpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:45:12 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:45406 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab0ENRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:45:09 -0400
Date: Fri, 14 May 2010 19:45:06 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100514174506.GD18740@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273768269.2295.1144.camel@rchatre-DESK>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Reinette,

  Might be of interest:

[63099.789939] eth1: associated
[63166.919257] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[63180.322024] Hangcheck: hangcheck value past margin!
[63190.664526] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[63193.255873] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[63194.941768] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[63195.099286] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[63196.524065] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[63197.417740] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[63199.767526] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:aa:aa:aa tid = 0
[63205.689184] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:aa:aa:aa tid = 0
[63210.821316] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:aa:aa:aa tid = 0
[63228.178530] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:aa:aa:aa tid = 0

Happened on site B, with high throughput (280-340k/s). So, it's happening w/ both, fast
and slow conn speed.

Yes, I noticed and had a look into the compat-wireless scripts but preferred to do 
it manually. Thank you for your explanation.

Cheers,

                Nils

