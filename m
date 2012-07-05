Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773Ab2GEPpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47182 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2GEPpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120703040446.GJ11413@one.firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
	<1341254598-1379-3-git-send-email-andi@firstfloor.org>
	<1341256733.23484.11.camel@twins>
	<20120702195744.GG11413@one.firstfloor.org>
	<1341260540.23484.25.camel@twins>
	<20120702210008.GB14479@tassilo.jf.intel.com>
	<1341265014.23484.47.camel@twins>
	<20120702215722.GC14479@tassilo.jf.intel.com>
	<CABPqkBSdtV6FTqVestcmy_skyK5AFTeShoT6vDFk34A0XaXWDA@mail.gmail.com>
	<20120703040446.GJ11413@one.firstfloor.org>
Date: Thu, 5 Jul 2012 17:45:16 +0200
Message-ID: <CABPqkBT4Dgte73hM+im0VP-Px1rXXURcyHhsSA2RYXCTZSdOxg@mail.gmail.com>
Subject: Re: [PATCH 2/5] perf, x86: Enable PDIR precise instruction profiling
 on IvyBridge
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 6:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Well, the only way I can think of would be to request that the
>> event be programmed with exclusive mode ALWAYS. That
>> should not be to hard to add.
>
> I suspect it would need some special callbacks from the events core,
> that's why I only tried on IvyBridge.
>x
You could simply add a check in the x86 init code like what is done
with the pebs events and precise mode.

> Anyways, I'll drop it as the people in charge didn't approve of
> instruction sampling.
>
> -Andi
