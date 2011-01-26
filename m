Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1AZTrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:47:21 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:48159 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751728Ab1AZTrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:47:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAD8JQE1Ld/sX/2dsb2JhbAAMhAbNfZEEgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,381,1291611600"; 
   d="scan'208";a="89335943"
Message-ID: <4D407A46.4080407@teksavvy.com>
Date: Wed, 26 Jan 2011 14:47:18 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com> <4D405A9D.4070607@redhat.com> <4D4076FD.6070207@teksavvy.com> <20110126194127.GE29268@core.coreip.homeip.net>
In-Reply-To: <20110126194127.GE29268@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 02:41 PM, Dmitry Torokhov wrote:
>
> I do not consider lsinput refusing to work a regression.

Obviously, since you don't use that tool.
Those of us who do use it see this as broken userspace compatibility.

Who the hell reviews this crap, anyway?
Code like that should never have made it upstream in the first place.

Cheers
