Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab1GGOzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:55:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:36590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab1GGOzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:55:17 -0400
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
In-Reply-To: <20110707145159.GD19193@elte.hu>
References: <20110707053036.173186930@google.com>
	 <20110707112302.GB8227@elte.hu> <1310049528.3282.583.camel@twins>
	 <20110707145159.GD19193@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 16:54:42 +0200
Message-ID: <1310050482.3282.584.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 16:51 +0200, Ingo Molnar wrote:
> > Going beyond that
> > would be using static_branch() to track if there is any bandwidth
> > tracking required at all.
> 
> Could jump labels be utilized perhaps? 

# git grep static_branch include/linux/
include/linux/jump_label.h:static __always_inline bool static_branch(struct jump_label_key *key)
