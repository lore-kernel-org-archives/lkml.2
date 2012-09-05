Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab2IERxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:53:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2IERxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:53:11 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=PUxD9mNbTSIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=mO6ojbDW-mgA:10 a=sCLvJZ4lsu0A:10 a=QJAQKYxhtbAA:10 a=30V3Ao2WuoAA:10 a=Auiyno6VaE4A:10 a=KtkL0iDH468A:10 a=zMj8phRcfKoA:10 a=ClXRDn1y_dXRzU6pUQsA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346867590.27919.60.camel@gandalf.local.home>
Subject: Re: [RFC PATCH v2] trace: Move trace event enable from fs_initcall
 to early_initcall
From: Steven Rostedt <rostedt@goodmis.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, tim.bird@am.sony.com,
        lizefan@huawei.com
Date: Wed, 05 Sep 2012 13:53:10 -0400
In-Reply-To: <CALF0-+WGTLQJQ-k3s11BjwpDnpJqByQuLEPttan+n4ecs2MQ5g@mail.gmail.com>
References: <1345204994-5400-1-git-send-email-elezegarcia@gmail.com>
	 <1345217308.3708.35.camel@gandalf.local.home>
	 <CALF0-+WGTLQJQ-k3s11BjwpDnpJqByQuLEPttan+n4ecs2MQ5g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 22:18 -0300, Ezequiel Garcia wrote:
> Hi Steven,
> 
> On 8/17/12, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2012-08-17 at 09:03 -0300, Ezequiel Garcia wrote:
> >> This patch splits trace event initialization in two stages:
> >>  * ftrace enable
> >>  * sysfs event entry creation
> >>
> >> This allows to capture trace events from an earlier point
> >> by using 'trace_event' kernel parameter and is important
> >> to trace boot-up allocations.
> >>
> >
> > This is much better, I'll give it some tests and add it to my 3.7 queue.
> >
> 
> Ping? Will you add this to your tree?

Yeah, I haven't been able to test it yet. I've been stuck trying to
figure out bugs on other patches I have queued. I'll let you know when I
do apply it though.

Thanks,

-- Steve


