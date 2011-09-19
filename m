Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1ISId6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:33:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:32941 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1ISId4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:33:56 -0400
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vladimir Davydov <VDavydov@parallels.com>
Cc: Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Jason Baron <jbaron@redhat.com>
Date: Mon, 19 Sep 2011 10:33:04 +0200
In-Reply-To: <BABF7462-9665-4BB1-B3BD-566A5A3D6F7A@parallels.com>
References: <20110721164325.231521704@google.com>
	 <1315915848.1151.26.camel@dhcp-10-30-22-158.sw.ru>
	 <4E730397.5030902@google.com>
	 <BABF7462-9665-4BB1-B3BD-566A5A3D6F7A@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316421184.1511.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 12:22 +0400, Vladimir Davydov wrote:
> But communicating tasks do not necessarily wake each other even if
> they exchange data through the pipe. And of course, if they use shared
> memory (e.g. threads), it is not obligatory at all. Also, the
> wake-affine path is cpu-load aware, i.e. it tries not to overload a
> cpu it is going to wake a task on. For instance, if we run a context
> switch test on an idle host, the two tasks will be executing on
> different cpus although it is better to execute them together on the
> same cpu.

This is not a problem specific to cgroups, and thus the solution
shouldn't ever live as something related to cgroups.


