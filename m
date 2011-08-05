Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1HEHVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:21:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58238 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1HEHVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:21:41 -0400
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead
 when bandwidth control is inactive
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        rth@redhat.com
Date: Fri, 05 Aug 2011 09:21:21 +0200
In-Reply-To: <CAPM31RKxBghZxcRyPLRv81Et0kxrYdBjzPohOONqHczr6EpDPA@mail.gmail.com>
References: <20110722003211.GA2807@redhat.com>
	 <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>
	 <20110722011747.GB2807@redhat.com>
	 <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
	 <20110727215816.GA2515@redhat.com>
	 <CAPM31RKxBghZxcRyPLRv81Et0kxrYdBjzPohOONqHczr6EpDPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312528881.10852.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 20:53 -0700, Paul Turner wrote:
> 
> I will re-post v7.3 with:
> - rebase to minor changes in tip
> - removing RFT from adding jump_labels to CFS
> - additional hierarchical period constraint 

Could you rebase to -tip + my patches, most of your previous set is
already queued there. The reason its not in -tip is is because the merge
window fallout still has -tip in a somewhat shaky state.
