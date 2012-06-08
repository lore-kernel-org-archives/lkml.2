Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2FHN77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:59:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:44653 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2FHN75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:59:57 -0400
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20120608135117.GB31359@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120608135117.GB31359@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 15:59:46 +0200
Message-ID: <1339163986.2507.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 15:51 +0200, Borislav Petkov wrote:
> Provided, of course, newer microcode versions means a
> higher version number. 

Fair enough, I assumed this.. is this true?

