Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab2BXQG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:06:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab2BXQGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:06:25 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=G9duDhSJBJJ_EBkZN3kA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330099582.25686.162.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        a.p.zijlstra@chello.nl, davem@davemloft.net, ddaney.cavm@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Feb 2012 11:06:22 -0500
In-Reply-To: <20120224090811.GB814@elte.hu>
References: <20120222075334.GA25053@elte.hu>
	 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
	 <20120222081855.GB25318@elte.hu>
	 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
	 <20120223100205.GD24310@elte.hu>
	 <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
	 <20120223223348.GA25513@elte.hu> <20120223223933.GA7942@elte.hu>
	 <20120223231842.GA31030@Krystal> <20120224022512.GA3777@redhat.com>
	 <20120224090811.GB814@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 10:08 +0100, Ingo Molnar wrote:

> So in the latest patch (still under testing, will push it out 
> soon) we have:
> 
> 	static_key_true()
> 	static_key_false()
> 	static_key_enabled()
> 
> > Also, I do like having a consistent 'static_key_*' prefix for 
> > the entire API - definitely an improvement for me.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


