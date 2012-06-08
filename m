Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2FHQuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:50:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57010 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FHQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:50:16 -0400
Date: Fri, 8 Jun 2012 18:50:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
Message-ID: <20120608165014.GB27374@one.firstfloor.org>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins> <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com> <1339065932.23343.18.camel@twins> <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com> <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com> <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339161972.2507.13.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why do we have per-cpu firmware anyway?

Consider CPU hotplug.  A newly plugged CPU is not updated yet, but will
be after hotplug.

However i suppose it would be possible to do the update early in the 
boot up sequence before others can use it. That would avoid this problem.

-Andi
