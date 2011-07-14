Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1GNNYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:24:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35646 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab1GNNYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:24:37 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=exgflK5sixEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=fMjEK6toXuGc-rMtJSEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] [RFCv3] perf: robustify proc and debugfs file recording
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Neuling <mikey@neuling.org>, Sonny Rao <sonnyrao@chromium.org>,
        acme@redhat.com, anton@samba.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310648130.2586.251.camel@twins>
References: <28585.1310602685@neuling.org>
	 <1310604019-10935-1-git-send-email-sonnyrao@chromium.org>
	 <1310612277.27864.5.camel@gandalf.stny.rr.com>
	 <10011.1310614483@neuling.org>
	 <1310647558.27864.19.camel@gandalf.stny.rr.com>
	 <1310648130.2586.251.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 09:24:35 -0400
Message-ID: <1310649875.27864.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 14:55 +0200, Peter Zijlstra wrote:

> Yeah, its all the rage, we're supposed to write full RFC compliant email
> parsers these days :(
> 

> Should decode that crap I think..

Thanks Peter! This seems to work.

-- Steve


