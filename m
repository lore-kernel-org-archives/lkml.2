Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab0EMPv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:51:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49286 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759137Ab0EMPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=q/pBtNgTcg0kNVYlqb4+mKGzCWib4QUMcaF1l8qx8O275gR+NvAAg2pDpFGMsHa18N
         /34nIOkkuTUqCchXBhS5xOwmOB8wyhN2HRPHKMfR6Su37EOKHdvSHyFv7fhkaRCw8d/u
         hLA645tbdH4WYxqnm/nwfCBoaU4E8mgey3+js=
MIME-Version: 1.0
In-Reply-To: <20100513145826.GJ30926@ghostprotocols.net>
References: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
	 <20100513145826.GJ30926@ghostprotocols.net>
Date: Thu, 13 May 2010 17:51:45 +0200
X-Google-Sender-Auth: UwUWyzxpqFT9Uj6LZjLsfzuTFC8
Message-ID: <AANLkTimLKfPHI81K_-N7gIkDXgenqOzNQlTvGFlCutvi@mail.gmail.com>
Subject: Re: perf: relative path to source for perf probe?
From: Chase Douglas <chase.douglas@canonical.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 4:58 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Probably you won't find this if you look at the old 2.6.34 codebase
> (yay, for tools/perf it is already hundreds of patches behind :-)), so
> I recomend you look at what we have in linux-2.6-tip, branch
> tip/perf/core, what is in 2.6.34 is in tip/perf/urgent and right now,
> IIRC, just a one patch that is not in 2.6.34 proper, a cherry-pick from
> tip/perf/core, no less :-)

Where are these branches? I've looked at:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=summary

but I don't see these branches listed.

Thanks for the pointers!

-- Chase
