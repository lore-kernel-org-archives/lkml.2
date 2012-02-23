Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2BWWoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:44:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2BWWoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:44:14 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=oJ9dV1UqH5jmDkvzhzoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330037050.25686.159.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Thu, 23 Feb 2012 17:44:10 -0500
In-Reply-To: <20120223223933.GA7942@elte.hu>
References: <20120221202019.GB2381@redhat.com>
	 <1329856745.25686.72.camel@gandalf.stny.rr.com>
	 <20120222073251.GB17291@elte.hu> <20120222075334.GA25053@elte.hu>
	 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
	 <20120222081855.GB25318@elte.hu>
	 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
	 <20120223100205.GD24310@elte.hu>
	 <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
	 <20120223223348.GA25513@elte.hu> <20120223223933.GA7942@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 23:39 +0100, Ingo Molnar wrote:

> Untested - will test it and will refactor the series if 
> everyone's happy.
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

;-)

-- Steve


