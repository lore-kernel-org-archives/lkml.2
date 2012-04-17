Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2DQJdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab2DQJdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:33:52 -0400
Date: Tue, 17 Apr 2012 11:33:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
Message-ID: <20120417093326.GA1650@m.brq.redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
 <1334503015.28150.16.camel@twins>
 <20120416121627.GA1660@m.brq.redhat.com>
 <1334589962.28150.69.camel@twins>
 <87lilud8so.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lilud8so.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 06:09:11PM +0900, Namhyung Kim wrote:
> Hi,
> 
> On Mon, 16 Apr 2012 17:26:02 +0200, Peter Zijlstra wrote:
> > On Mon, 2012-04-16 at 14:16 +0200, Jiri Olsa wrote:
> >> group:        group_spec '{' events '}'
> >> group_spec:   name  ':' mod | empty 
> >
> > How about something like:
> >
> > groups: groups ',' group | group
> > group:	group_name '{' events '}' group_mod
> > group_name: name ':' | empty
> > group_mod: ':' group_mods | empty
> > group_mods: [l]
> 
> Wouldn't it be better if group_mods accepts [ukhHGp] also and pass them
> to all members in the group?

nice idea, I think it's doable

jirka
