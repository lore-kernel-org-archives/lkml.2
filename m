Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0JQJjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 05:39:18 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43415 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab0JQJjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 05:39:17 -0400
Subject: Re: [RFC tg_shares_up improvements - v1 00/12] [RFC tg_shares_up -
 v1 00/12] Reducing cost of tg->shares distribution
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: pjt@google.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
In-Reply-To: <20101017052454.GA21273@balbir.in.ibm.com>
References: <20101016044349.830426011@google.com>
	 <20101017052454.GA21273@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 11:38:51 +0200
Message-ID: <1287308331.1998.135.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 10:54 +0530, Balbir Singh wrote:
> 
> The results do sound interesting, could I recommend that you try to
> get 1000 cgroups or so, with half of them as active and half inactive.
> I'd also suggest tracking system and user time at the cgroup level. 

Sure, but do keep in mind that 500 active cgroups will always utterly
suck no matter what you do, it means we do indeed need to iterate 500
cgroups for a lot of scheduler operations.


