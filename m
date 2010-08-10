Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0HJLXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 07:23:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458Ab0HJLXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 07:23:16 -0400
Message-ID: <4C613627.1090907@suse.cz>
Date: Tue, 10 Aug 2010 13:21:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Roland McGrath <roland@redhat.com>, Roland Dreier <rdreier@cisco.com>,
        Tiago Maluta <tiago.maluta@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>	<20100621120613.86cad1a4.akpm@linux-foundation.org>	<4C1FC35C.8090201@suse.cz>	<AANLkTil2-YNAa-jyOYD4cNtbJQ1XQJ6-v3iJ6wxpz7br@mail.gmail.com>	<AANLkTinC6Sqs7W--=14nmJFDcTS4HQn0=ysn7VhYDDX6@mail.gmail.com>	<adaocdg3fng.fsf@roland-alpha.cisco.com>	<20100805222623.39A3240208@magilla.sf.frob.com> <AANLkTikvRqTR6TjP9H4-_RHhax24YRPv9PCxn165RTWs@mail.gmail.com>
In-Reply-To: <AANLkTikvRqTR6TjP9H4-_RHhax24YRPv9PCxn165RTWs@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.8.2010 08:43, Yegor Yefremov wrote:
> On Fri, Aug 6, 2010 at 12:26 AM, Roland McGrath <roland@redhat.com> wrote:
>>> Yes, this make sense to me.  It's not clear to me why we ever needed
>>> the conditional assignment of an empty CROSS_COMPILE (that code predates
>>> the start of git history) [...]
>>
>> Perhaps someone used make --warn-undefined-variables.
> 
> Are there any other comments or is the patch valid? Should I resend it
> as a new thread?

No problem at your side, the patch is fine and I applied it now.

Michal
