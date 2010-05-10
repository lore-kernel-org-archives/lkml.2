Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0EJLqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:46:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:45828 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0EJLqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:46:33 -0400
Subject: Re: [PATCH 12/25] lmb: Move lmb arrays to static storage in lmb.c
 and make their size a variable
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net
In-Reply-To: <20100510104446.GC14278@linux-sh.org>
References: <1273484339-28911-4-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-5-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-6-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-7-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-8-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-9-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-10-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-11-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-12-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-13-git-send-email-benh@kernel.crashing.org>
	 <20100510104446.GC14278@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 21:46:14 +1000
Message-ID: <1273491974.23699.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 19:44 +0900, Paul Mundt wrote:
> Perhaps it would be better to weight this against MAX_ACTIVE_REGIONS
> for the ARCH_POPULATES_NODE_MAP case? The early node map is already
> using that size, at least. 

Well, one of the next patches implement dynamic resize of the LMB array
so I was actually thinking about shrinking the static one to a
minimum...

Cheers,
Ben.


