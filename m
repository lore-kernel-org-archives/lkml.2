Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0EYIO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:14:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:56192 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab0EYIO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:14:58 -0400
Subject: Re: [RFC PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Paul Turner <pjt@google.com>
In-Reply-To: <1274746282-21533-1-git-send-email-venki@google.com>
References: <1274746282-21533-1-git-send-email-venki@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 May 2010 10:14:37 +0200
Message-ID: <1274775277.5882.482.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Argh - you managed to use chain-reply with git-1.7? 
