Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0H1Whh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 18:37:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:47558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0H1Whg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 18:37:36 -0400
Message-Id: <20100828223025.054328145@chello.nl>
User-Agent: quilt/0.47-1
Date: Sun, 29 Aug 2010 00:30:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
Subject: [RFC][PATCH 0/3] Try and make cpu-cgroup suck less
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches try and make cpu-cgroup suck less.. 

Didn't test the RT changes much at all, did poke a little at the FAIR bits.

