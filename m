Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2GQPsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:48:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2GQPr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:47:59 -0400
Date: Tue, 17 Jul 2012 17:47:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ulrich Drepper <drepper@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, acme@redhat.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
Message-ID: <20120717154753.GK11413@one.firstfloor.org>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com> <87fw9blyhj.fsf@sejong.aot.lge.com> <20120702101518.GC967@krava.redhat.com> <1341234662.1476.13.camel@leonhard> <20120702133341.GD967@krava.redhat.com> <CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com> <CAOPLpQfWtyRHYT1ZfcdmshYoapBgF=FO7yFacYe8pyL0MBeebA@mail.gmail.com> <CABPqkBTTZaCVTtwJZbjXGwAihKAW_PMFK0+TZUTvbOn4pnfzvA@mail.gmail.com> <20120709110528.GA965@krava.redhat.com> <CABPqkBTGOvSuCfOUt=gnpfViVn8Whg0Mf7_3dUUim-iXA+8gjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTGOvSuCfOUt=gnpfViVn8Whg0Mf7_3dUUim-iXA+8gjA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To me ,this looks a bit of an over-engineered design and it is not based on
> any actual user requests. Don't get me wrong, grouping is useful and required
> but nobody has ever asked for that level of flexibility. The syntax you have
> now is already very rich for my taste.

The user input I hear is just get the basic support working ASAP.

-Andi
