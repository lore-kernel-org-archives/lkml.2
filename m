Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2GILQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:16:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:47212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2GILQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:16:00 -0400
Message-ID: <1341832543.3462.38.camel@twins>
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, Ulrich Drepper <drepper@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Date: Mon, 09 Jul 2012 13:15:43 +0200
In-Reply-To: <20120709110528.GA965@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	 <87fw9blyhj.fsf@sejong.aot.lge.com> <20120702101518.GC967@krava.redhat.com>
	 <1341234662.1476.13.camel@leonhard> <20120702133341.GD967@krava.redhat.com>
	 <CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
	 <CAOPLpQfWtyRHYT1ZfcdmshYoapBgF=FO7yFacYe8pyL0MBeebA@mail.gmail.com>
	 <CABPqkBTTZaCVTtwJZbjXGwAihKAW_PMFK0+TZUTvbOn4pnfzvA@mail.gmail.com>
	 <20120709110528.GA965@krava.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 13:05 +0200, Jiri Olsa wrote:
> <peterz> the {} thing allows: 1) multiple groups in a single -e

The advantage would be when you're passing such things on via
environment variables or somesuch.
