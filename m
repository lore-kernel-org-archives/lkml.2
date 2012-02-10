Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab2BJN12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:27:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab2BJN10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:27:26 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=eSfxnIkts4oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Y5qM8XDBzt9pMIbPRgsA:9 a=FFuwIW3Ic1X59vNOULsA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328880444.8273.3.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv8 0/8] ftrace, perf: Adding support to use function trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 10 Feb 2012 08:27:24 -0500
In-Reply-To: <1328643899-8361-1-git-send-email-jolsa@redhat.com>
References: <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1328643899-8361-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 20:44 +0100, Jiri Olsa wrote:
> hi,
> here's another version of perf support for function trace
> with filter. 

OK, I've applied all of these and I'm now going to run them through my
test suite before sending them to Ingo. I'll let you know if anything
goes wrong.

Also, in the future, PLEASE do not send a new version of the patches as
a reply to a previous version. It's OK to do so for a single patch, if
you only modified one patch of a series. But don't make a full series a
reply of the last series. It just screws up my inbox.

Thanks!

-- Steve


