Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247Ab2FHODo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:03:44 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61648 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933468Ab2FHODk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:03:40 -0400
MIME-Version: 1.0
In-Reply-To: <1339163986.2507.19.camel@laptop>
References: <20120607071531.GA4849@quad>
	<1339064319.23343.13.camel@twins>
	<CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	<1339065932.23343.18.camel@twins>
	<CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	<1339067757.23343.21.camel@twins>
	<20120608093513.GA22520@gmail.com>
	<1339149613.23343.52.camel@twins>
	<1339161972.2507.13.camel@laptop>
	<20120608135117.GB31359@aftab.osrc.amd.com>
	<1339163986.2507.19.camel@laptop>
Date: Fri, 8 Jun 2012 16:03:38 +0200
Message-ID: <CABPqkBSAO_7W_pN+uq0uy-vaciBEE57oNF9Q6s_o39SBVWbc3Q@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 3:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-06-08 at 15:51 +0200, Borislav Petkov wrote:
>> Provided, of course, newer microcode versions means a
>> higher version number.
>
> Fair enough, I assumed this.. is this true?
>
I would think so, otherwise it gets even messier!
