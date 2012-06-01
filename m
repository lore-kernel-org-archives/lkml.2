Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab2FARxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:53:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54166 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759632Ab2FARxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:53:41 -0400
Date: Fri, 1 Jun 2012 10:50:26 -0700
From: Zachary Landau <zacharyl@fb.com>
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Sunjin Yang <fan4326@gmail.com>
Subject: Re: [PATCH 1/2] perf callchain: Make callchain cursors TLS
Message-ID: <20120601175026.GA11806@dev4103.snc6.facebook.com>
References: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-06-01_05:2012-05-21,2012-06-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 02:43:26PM +0900, Namhyung Kim wrote:
> perf top -G has a race on callchain cursor between main
> thread and display thread. Since the callchain cursors
> are used locally make them thread-local data would solve
> the problem.
> 
> Reported-by: Sunjin Yang <fan4326@gmail.com>
> Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>

Acked-by: Zachary Landau <zacharyl@fb.com>

- Zack
