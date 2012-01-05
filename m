Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2AEPe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:34:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33753 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2AEPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:34:25 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=sfBY0qdRI6cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=W56QP2Vyh2sB7kVpmCsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325777664.12696.50.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] jump label: close race in jump_label_inc() vs.
 jump_label_dec()
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: gleb@redhat.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 10:34:24 -0500
In-Reply-To: <20120105153041.GA10850@redhat.com>
References: <201201041532.q04FWbBl022103@int-mx10.intmail.prod.int.phx2.redhat.com>
	 <1325774396.12696.49.camel@gandalf.stny.rr.com>
	 <20120105153041.GA10850@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 10:30 -0500, Jason Baron wrote:

> That said, until we have a use-case that would excercise this race,
> I'm ok with having it be a higher level bug as Gleb pointed out. So how about a
> WARN() for this case. I'll send as a separate patch, if people are ok
> with it.

You mean a WARN_ON(key->enabled < 0) ?

for that, yeah I'm fine with it.

-- Steve


