Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2FDRCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:02:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53682 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855Ab2FDRCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:02:54 -0400
Message-ID: <4FCCE9F5.9050808@fb.com>
Date: Mon, 4 Jun 2012 10:01:41 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Vagin <avagin@openvz.org>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
References: <1338797382-287275-1-git-send-email-avagin@openvz.org> <1338813658.28282.43.camel@twins>
In-Reply-To: <1338813658.28282.43.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-06-04_03:2012-05-21,2012-06-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/12 5:40 AM, Peter Zijlstra wrote:

> And as a result you need that hideous prev_state crap.
>
>
> Would something like the below work?
>
> The one thing I'm not entirely sure of is if this is a sekjoerity issue
> or not.. anybody? I would think a task was entitled to know who woke it
> and wherefrom etc..

Frederic had some comments on this topic in the last round:

http://thread.gmane.org/gmane.linux.kernel/1195368/focus=1195959

 > We should probably avoid the remote callchains, sounds like asking 
for complications everywhere.

Do they still apply? Frederic?

  -Arun
