Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1GYRLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:11:42 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58747 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <1311613694.24752.8.camel@twins>
References: <20110721164325.231521704@google.com>
	<1311605881.24752.2.camel@twins>
	<1311606041.24752.3.camel@twins>
	<20110725162133.GI2327@linux.vnet.ibm.com>
	<1311611311.24752.5.camel@twins>
	<20110725164619.GK2327@linux.vnet.ibm.com>
	<1311613694.24752.8.camel@twins>
Date: Mon, 25 Jul 2011 10:11:38 -0700
Message-ID: <CAPhKKr-+sss_Q+SLCFWbdQdcCG2rn93Hh8KH7p3eG35AWvsRJQ@mail.gmail.com>
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I consider setting the cgroup paramaters an utter slow path, and if
> people complain I'll simply tell them to sod off ;-)
>

cgroups parameters? I can think of some funky uses if setting cgroup
parameters was not in the slow path. I think you meant create/destroy
cgroups here :-).

Dhaval
