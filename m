Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2AZOH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:07:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2AZOH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:07:28 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0LOP1KteNnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=wEcsVv2XF_e0zPuac84A:9 a=PUjeQqilurYA:10 a=Ti_uA8_mJTmcI9el:21 a=QuPJplAy6ombxOx-:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327586847.22710.90.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Thu, 26 Jan 2012 09:07:27 -0500
In-Reply-To: <1327586669.22710.89.camel@gandalf.stny.rr.com>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
	 <20120117095418.GG10397@elte.hu>
	 <1326807145.17534.26.camel@gandalf.stny.rr.com>
	 <20120118120711.GB14863@elte.hu>
	 <1326909412.17534.91.camel@gandalf.stny.rr.com>
	 <877h0jgx80.fsf@rustcorp.com.au>
	 <1327545664.22710.78.camel@gandalf.stny.rr.com>
	 <20120126102836.GD3853@elte.hu>
	 <1327585945.22710.87.camel@gandalf.stny.rr.com>
	 <20120126135504.GA13107@elte.hu>
	 <1327586669.22710.89.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 09:04 -0500, Steven Rostedt wrote:

> Perhaps I could use "__builtin_return_address(0)" instead.

s/__builtin_return_address(0)/_RET_IP_/

-- Steve


