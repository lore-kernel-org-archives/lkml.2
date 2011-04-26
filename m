Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab1DZUv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:51:57 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:38324 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1DZUvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:51:55 -0400
Date: Tue, 26 Apr 2011 16:51:08 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
In-Reply-To: <20110426073847.GB30630@elte.hu>
Message-ID: <alpine.DEB.2.00.1104261648400.32482@cl320.eecs.utk.edu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org> <1303407662-15564-2-git-send-email-acme@infradead.org> <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu> <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu> <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu> <20110426073847.GB30630@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, Ingo Molnar wrote:

> The kernel development process is in essence an abstraction engine, and if you 
> expect something else you'll probably be facing a lot of frustrating episodes 
> in the future as well where others try to abstract out meaningful 
> generalizations.

yes, but you are taking abstraction to the extreme.

A filesystem abstracts out the access to raw disk... but under Linux we 
still allow raw access to /dev/sda

TCP/IP abstracts out the access to the network... but under Linux we still 
allow creating raw packets.

It is fine to have some sort of high-level abstraction of perf events for 
those who don't have PhDs in computer architecture.  Fine.  But don't get 
in the way of people who know what they are doing.

Vince
