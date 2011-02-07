Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1BGVcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:32:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1BGVcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:32:50 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=CoHOllCSD4cA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=mDV3o1hIAAAA:8 a=A0SP27yD7xIXQrL8MbUA:9 a=kZbi2jgiESBxHJRMR8AC8E_urQ4A:4 a=PUjeQqilurYA:10 a=FYyigxLieOIA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 0/4] tracing,x86_64 - function/graph trace without
 mcount/-pg/framepointer
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110207212220.GA30070@feather>
References: <20110207212220.GA30070@feather>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 07 Feb 2011 16:32:47 -0500
Message-ID: <1297114367.23343.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 13:22 -0800, Josh Triplett wrote:

> GCC 4.6 may help here.  According to
> http://gcc.gnu.org/gcc-4.6/changes.html:
> 
> "Support for emitting profiler counter calls before function prologues.
> This is enabled via a new command-line option -mfentry."
> 
> Looks like that option might only support x86 (32-bit and 64-bit) at the
> moment, but it still seems like an improvement over the current
> mechanism to work around GCC's placement of mcount.
> 

I may need to download this and try it out.

Thanks for the reference!

-- Steve


