Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2GBNLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:11:13 -0400
Received: from mail-yw0-f42.google.com ([209.85.213.42]:61781 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2GBNLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:11:12 -0400
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com, eranian@google.com
In-Reply-To: <20120702101518.GC967@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	 <87fw9blyhj.fsf@sejong.aot.lge.com> <20120702101518.GC967@krava.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jul 2012 22:11:02 +0900
Message-ID: <1341234662.1476.13.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-07-02 (월), 12:15 +0200, Jiri Olsa:
> On Mon, Jul 02, 2012 at 10:53:44AM +0900, Namhyung Kim wrote:
> > Just a question, is there a way to know about the grouping at perf
> > report time?
> 
> nope, AFAIK only ID and perf_event_attr is stored for event
> grouping is known only for record time
> 

I heard that Arnaldo (or Stephane) wanted to make perf report
group-aware or such so that it can show related events together. But to
do that, it seems we need to change the data file format first, right?

Any idea?


-- 
Regards,
Namhyung Kim


