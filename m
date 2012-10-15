Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2JORXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:23:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60575 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752987Ab2JORXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:23:45 -0400
Message-ID: <507C467E.8010205@fb.com>
Date: Mon, 15 Oct 2012 10:23:10 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, <acme@redhat.com>,
        <mingo@kernel.org>, <peterz@infradead.org>, <eranian@google.com>,
        "Anton Blanchard" <anton@au1.ibm.com>, <paulus@samba.org>,
        <mpjohn@us.ibm.com>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
References: <20121012012839.GA15348@us.ibm.com> <20121015155534.GR8285@erda.amd.com>
In-Reply-To: <20121015155534.GR8285@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.254]
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-15_04:2012-10-15,2012-10-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/12 8:55 AM, Robert Richter wrote:

[..]
> Perf tool works then out-of-the-box with:
>
>   $ perf record -e cpu/stalled-cycles-fixed-point/ ...
>
> The event string can easily be reused by other architectures as a
> quasi standard.

I like Robert's proposal better. It's hard to model all the stall events 
(eg: instruction decoder related stalls on x86) in a hardware 
independent way.

Another area to think about: software engineers are generally busy and 
have a limited amount of time to devote to hardware event based 
optimizations. The most common question I hear is: what is the expected 
perf gain if I fix this? It's hard to answer that with just the stall 
events.

  -Arun
