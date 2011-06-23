Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab1FWRoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:44:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab1FWRoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:44:13 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=zF--ts7PbwgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=uNXtD-5xgFl1CPuuO2AA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2] jump_label: fix jump_label update
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4E033557.3030007@redhat.com>
References: <4E00038B.2060404@cn.fujitsu.com> <4E033004.90008@redhat.com>
	 <4E033557.3030007@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Jun 2011 13:44:10 -0400
Message-ID: <1308851050.531.33.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 15:45 +0300, Avi Kivity wrote:
> On 06/23/2011 03:22 PM, Avi Kivity wrote:
> > On 06/21/2011 05:35 AM, Xiao Guangrong wrote:
> >> The key of module is out of __stop___jump_table, it causes the events
> >> of modules does not work
> >>
> >
> > What's the status of this patch? 
> 
> Oh, it's just two days out.  Didn't mean to sound impatient.

I've been working on other things than tracing lately.

> 
> > I'm affected by this as well (I'm guessing the same module is 
> > involved).  I'm near the end of a bisect, but there's probably no 
> > point given this patch.
> >
> 
> I can confirm it fixes my issue.
> 
> Tested-by: Avi Kivity <avi@redhat.com>
> 

Thanks, I'll queue it up for 3.0 and start my tests on it.

-- Steve


