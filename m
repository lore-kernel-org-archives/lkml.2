Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab0EYQ2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:28:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:42206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab0EYQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:28:19 -0400
Message-ID: <4BFBFA83.3000501@kernel.org>
Date: Tue, 25 May 2010 18:27:47 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Make sure timers have migrated before killing	migration_thread
References: <20100519090557.GA15237@amitarora.in.ibm.com> <1274261515.5605.10423.camel@twins> <20100524095951.GA17680@amitarora.in.ibm.com> <1274787095.5882.949.camel@twins> <20100525132346.GA14986@amitarora.in.ibm.com>
In-Reply-To: <20100525132346.GA14986@amitarora.in.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 25 May 2010 16:27:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
