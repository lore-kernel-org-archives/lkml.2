Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab1GSQE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:04:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:8477 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab1GSQEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,229,1309762800"; 
   d="scan'208";a="29800984"
Date: Tue, 19 Jul 2011 17:05:53 +0100
From: Alan Cox <alan@linux.intel.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 2/2] serial:blackfin: rename Blackfin serial driver to
 bfin_uart.c
Message-ID: <20110719170553.2364ef7a@bob.linux.org.uk>
In-Reply-To: <1311070165-29402-2-git-send-email-sonic.adi@gmail.com>
References: <1311070165-29402-1-git-send-email-sonic.adi@gmail.com>
	<1311070165-29402-2-git-send-email-sonic.adi@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me - and thanks for splitting the move and the style
changes into two patches

Acked-by: Alan Cox <alan@linux.intel.com>

