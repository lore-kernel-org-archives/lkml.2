Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab1CRJiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:38:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:33080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1CRJiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:38:13 -0400
Subject: Re: [RFC][PATCH 09/14] sched: Dynamically allocate
 sched_domain/sched_group data-structures
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <AANLkTi=sDHEAMK0fWF07brEd6WEki0Sffmgcy3LkERK3@mail.gmail.com>
References: <20110314150613.749843433@chello.nl>
	 <20110314152227.191956337@chello.nl>
	 <AANLkTi=sDHEAMK0fWF07brEd6WEki0Sffmgcy3LkERK3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Mar 2011 10:37:41 +0100
Message-ID: <1300441061.21794.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 14:38 +0530, Bharata B Rao wrote:
> sa_send_covered enum member can be removed, since you no longer seem
> to be using it. 

Indeed, thanks!
