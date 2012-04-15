Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2DOPRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 11:17:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:45036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab2DOPRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 11:17:18 -0400
Message-ID: <1334503015.28150.16.camel@twins>
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Date: Sun, 15 Apr 2012 17:16:55 +0200
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 23:16 +0200, Jiri Olsa wrote:
> - added 'group=...' syntax to group events (patches 1-5).

> - added 'group:1=...' syntax to specify which event to sample (leader) 

I'm still sad about not actually using {} for grouping. Esp. since you
use ';' which needs escaping anyway:

> perf record -e 'group=cycles,faults;group=instructions,cache-misses' ls

Also, how do you name the groups?
