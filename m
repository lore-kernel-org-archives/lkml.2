Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2FSOoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:44:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4267 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab2FSOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:44:15 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ARy8Wg5PTaYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=e2kuwfKXyx8fExrQZdIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340117052.25903.258.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd
 plugins
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Date: Tue, 19 Jun 2012 10:44:12 -0400
In-Reply-To: <87vcin9xi1.fsf@gmail.com>
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
	 <87lijlhv9v.fsf@sejong.aot.lge.com> <4FDF3D5C.1030209@gmail.com>
	 <87d34wi0y3.fsf@sejong.aot.lge.com>
	 <1340067793.25903.158.camel@gandalf.stny.rr.com>
	 <878vfkhzr8.fsf@sejong.aot.lge.com>
	 <1340069162.25903.176.camel@gandalf.stny.rr.com>
	 <874nq8hyfa.fsf@sejong.aot.lge.com>
	 <1340072171.25903.181.camel@gandalf.stny.rr.com>
	 <87vcinhn90.fsf@sejong.aot.lge.com>
	 <1340106882.25903.206.camel@gandalf.stny.rr.com> <87vcin9xi1.fsf@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 23:39 +0900, Namhyung Kim wrote:
> On Tue, 19 Jun 2012 07:54:42 -0400, Steven Rostedt wrote:
> > We could simply check if all the characters in the array passes
> > 'isprint()' and if it does then print the string, otherwise print the
> > hex. Do this for all events, and if it one fails, then mark it always to
> > print hex.
> >
> 
> Ok, checking it at parse time is not possible because we cannot access
> to its data. You meant something like this?
> 

Exactly!

-- Steve


