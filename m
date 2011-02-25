Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab1BYTeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:34:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754Ab1BYTeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:34:06 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=B6-kwD8izM94doaw5-AA:9 a=nLKbQ-GPzw8VnfJsC8rgzxwj9pMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Ftracing in linux kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Erlon Cruz <sombrafam@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimG7QacpnfC24QH9-QzQVTLT+xEU8Vhk1x6vq2Q@mail.gmail.com>
References: <AANLkTinDf2odDs2a9Wc0d4T8hxV6sj5GmgOs_p_3VHQP@mail.gmail.com>
	 <AANLkTimG7QacpnfC24QH9-QzQVTLT+xEU8Vhk1x6vq2Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Feb 2011 14:34:03 -0500
Message-ID: <1298662443.6376.20.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 11:21 -0300, Erlon Cruz wrote:
> Hi folks,
> 
>    I've configured my kernel(2.6.35) to support ftrace*. Everything
> seems to be ok. After I mounted the debugfs folder I can find all
> tracing stuffs there. The problem is not of all functions on my module
> seems to be listed in the funtions supported for tracing. In the file
> available_filter_functions that suppose to list all functions traced,
> only show 4 or 5 functions of my module. Does anyone knows why some
> functions are not listed?

Are those functions inlined? If gcc inlines a function (regardless if
you say to or not) it will not be traced. If you want to trace them just
force them to not inline with "noinline".

-- Steve


