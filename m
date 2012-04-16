Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2DPPiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab2DPPiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:38:24 -0400
Date: Mon, 16 Apr 2012 17:37:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
Message-ID: <20120416153739.GB1660@m.brq.redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
 <1334503015.28150.16.camel@twins>
 <20120416121627.GA1660@m.brq.redhat.com>
 <1334589962.28150.69.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334589962.28150.69.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 05:26:02PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-16 at 14:16 +0200, Jiri Olsa wrote:
> > group:        group_spec '{' events '}'
> > group_spec:   name  ':' mod | empty 
> 
> How about something like:
> 
> groups: groups ',' group | group
> group:	group_name '{' events '}' group_mod
> group_name: name ':' | empty
> group_mod: ':' group_mods | empty
> group_mods: [l]
> 
> 

so you'd like something like:
  'group1:{cycles,faults}:1

hm, do you want the ':' behind the name? It does not seem necessary,
but might be readable though.. ok :)
  'group1{cycles,faults}:1

thanks,
jirka
