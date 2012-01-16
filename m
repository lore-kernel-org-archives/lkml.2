Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2APQte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:49:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:7412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab2APQtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:49:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="99153454"
Date: Mon, 16 Jan 2012 17:02:51 +0000
From: Alan Cox <alan@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of
 failing probe
Message-ID: <20120116170251.3e5d07cd@bob.linux.org.uk>
In-Reply-To: <20120116164424.GA19621@sirena.org.uk>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AF47@saturn3.aculab.com>
	<4F1451BD.9030904@linux.intel.com>
	<20120116164424.GA19621@sirena.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> bootloader configuration) - for a lot of applications random
> generation doesn't help that much as entropy is hard to come by.

This is an x86 platform - plenty of entropy from the tsc etc.

