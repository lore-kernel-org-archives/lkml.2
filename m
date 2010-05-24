Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab0EXN32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 09:29:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab0EXN31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 09:29:27 -0400
Subject: Re: [PATCH] Make sure timers have migrated before killing
 migration_thread
From: Peter Zijlstra <peterz@infradead.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: tj@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100524095951.GA17680@amitarora.in.ibm.com>
References: <20100519090557.GA15237@amitarora.in.ibm.com>
	 <1274261515.5605.10423.camel@twins>
	 <20100524095951.GA17680@amitarora.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 May 2010 15:28:45 +0200
Message-ID: <1274707726.5605.31932.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 15:29 +0530, Amit K. Arora wrote:
> since _cpu_up() and _cpu_down() can never run in
> parallel, because of cpu_add_remove_lock. 

Ah indeed. I guess your initial patch works then. 


