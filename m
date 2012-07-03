Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2GCEEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:04:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43863 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2GCEEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:04:52 -0400
Date: Tue, 3 Jul 2012 06:04:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/5] perf, x86: Enable PDIR precise instruction profiling on IvyBridge
Message-ID: <20120703040446.GJ11413@one.firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org> <1341254598-1379-3-git-send-email-andi@firstfloor.org> <1341256733.23484.11.camel@twins> <20120702195744.GG11413@one.firstfloor.org> <1341260540.23484.25.camel@twins> <20120702210008.GB14479@tassilo.jf.intel.com> <1341265014.23484.47.camel@twins> <20120702215722.GC14479@tassilo.jf.intel.com> <CABPqkBSdtV6FTqVestcmy_skyK5AFTeShoT6vDFk34A0XaXWDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSdtV6FTqVestcmy_skyK5AFTeShoT6vDFk34A0XaXWDA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, the only way I can think of would be to request that the
> event be programmed with exclusive mode ALWAYS. That
> should not be to hard to add.

I suspect it would need some special callbacks from the events core,
that's why I only tried on IvyBridge.

Anyways, I'll drop it as the people in charge didn't approve of 
instruction sampling.

-Andi
