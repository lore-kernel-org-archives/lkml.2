Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2KPAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:16:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19042 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2KPAQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:16:58 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-zCuM0TdcCYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=apWNB6VHehcA:10 a=D19gQVrFAAAA:8 a=7f-vXm5hu6nXF3h8P9AA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353025016.9391.1.camel@gandalf.local.home>
Subject: Re: [PATCH v2 -tip 0/4] tracing: make a snapshot feature available
 from userspace
From: Steven Rostedt <rostedt@goodmis.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org
Date: Thu, 15 Nov 2012 19:16:56 -0500
In-Reply-To: <20121017025608.2627.87497.stgit@falsita>
References: <20121017025608.2627.87497.stgit@falsita>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 11:56 +0900, Hiraku Toyooka wrote:
> Hi, Steven,
> 
> Thank you for your review.
> I changed the function name "resize_buffer_even" to 
> "resize_buffer_duplicate_size".
> 
> (v1: https://lkml.org/lkml/2012/10/2/67)
> 

OK, I finally got around to start playing with it. There's some things I
started to fix, but decided I'll just throw them back at you ;-)

I'll comment on the individual patches.

-- Steve


