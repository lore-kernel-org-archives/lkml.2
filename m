Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab2ENIJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:09:07 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:59797 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2ENIJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:09:03 -0400
Message-ID: <4FB0BD92.5030202@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 16:08:50 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: About dynamic schedule domain
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051408-8256-0000-0000-0000026DA6B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

I have read the mail thread on the topic about dynamic sched domain in link:
http://marc.info/?l=linux-kernel&m=130822782111533&w=2

But I'm not sure, is the dynamical sched domain means we can change the
sched domain at running time through proc or something else?

If it is still pending on implementation, could you please tell me how
things going on and what's the idea you have mentioned in the mail?

I want to do some help if I could :)

Regards,
Michael Wang

