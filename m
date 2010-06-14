Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0FNQ6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:58:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:36431 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab0FNQ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,415,1272870000"; 
   d="scan'208";a="576254113"
Subject: Re: iwlagn completely unusable with some AP since 2.6.31
From: reinette chatre <reinette.chatre@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100614160910.GA10738@gandalf.dynalias.org>
References: <20100614160910.GA10738@gandalf.dynalias.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 09:58:42 -0700
Message-ID: <1276534722.25793.1425.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

On Mon, 2010-06-14 at 09:09 -0700, Norbert Preining wrote:
> Dear all,
> 
> (please cc)

Since you are a regular poster to the wireless lists and you also
submitted a bug report
(http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214 ) for this
issue it does not seem as though you need help in sending this to the
appropriate people. 

> [13341.695599] iwlagn 0000:06:00.0: iwlagn_tx_agg_start on ra = 00:0a:79:eb:56:10 tid = 0
> [13733.621786] iwlagn 0000:06:00.0: Received BA when not expected
> [13733.621800] iwlagn 0000:06:00.0: Read index for DMA queue txq id (0), index 15, is out of range [0-256] 17 17.
> [13734.188691] iwlagn 0000:06:00.0: Received BA when not expected
> [13734.188704] iwlagn 0000:06:00.0: Read index for DMA queue txq id (0), index 16, is out of range [0-256] 18 18.
> 
> and here it continues with many many many of those two lines. The only
> way to resurrect the wifi card is unloading iwlagn and reloading it.

... as I mention above you already submitted a bug report for this issue
and we directed you to a patch that addresses this. You have not replied
to that suggestion with any testing, instead you posted this message on
lkml. 

> 
> I have no idea where to go from here,

How about you test the patch we proposed and work with the developers
working on your bug report?

Reinette


