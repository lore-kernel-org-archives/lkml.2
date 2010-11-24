Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0KXAfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:35:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59669 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0KXAfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:35:42 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=fIAfbhESzNEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=Yj3xZIQRpWuvJPA9bdoA:9 a=WVX5W1_AfFtbkA2vsWXQk4R88tIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/3] jump label: move jump table to r/w section
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101124002703.GB29158@Krystal>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <bbc34a86a4cf4addcde1b85d7fa7faecc0966c03.1290546539.git.jbaron@redhat.com>
	 <20101123235519.GB21549@Krystal>
	 <1290557049.30543.417.camel@gandalf.stny.rr.com>
	 <20101124002703.GB29158@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 19:35:39 -0500
Message-ID: <1290558939.30543.421.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 19:27 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> The lack of proper alignment did cause nasty hard-to-identify/reproduce
> regressions based on the compiler used, target platform and data layout.
> It's up to you, but I'd be much more comfortable merging this in 2.6.37.

Hmm, I may add a patch on top to apply it.

-- Steve


