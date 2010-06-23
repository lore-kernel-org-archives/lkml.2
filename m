Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab0FWHVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:21:42 -0400
Received: from col0-omc1-s1.col0.hotmail.com ([65.55.34.11]:5316 "EHLO
	col0-omc1-s1.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab0FWHVl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:21:41 -0400
Message-ID: <COL124-W5CE66C5698374CFC14521D6C50@phx.gbl>
X-Originating-IP: [178.128.47.180]
From: =?iso-8859-7?B?wevd7uHt5PHv8iDQ4fDh5O/j6eHt7dzq5/I=?= 
	<psxlover@hotmail.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>, <mingo@elte.hu>
Subject: RE: sched_setaffinity not working with kernel 2.6.32.15
Date: Wed, 23 Jun 2010 10:20:00 +0300
Importance: Normal
In-Reply-To: <20100622171622.fc9d04c1.akpm@linux-foundation.org>
References: <COL124-W1850C30E9FF3BFB06DF5BFD6C20@phx.gbl>,<20100622171622.fc9d04c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Jun 2010 07:20:00.0422 (UTC) FILETIME=[7DC57460:01CB12A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the reply. I first send a msg to Peter and Ingo and then someone
suggested I should also send it to the kernel mailing list so I forwarded 
it. Don't worry I didn't get any reply yet.

About the testcase, seems like I accidentaly commented:
    //pthread_barrier_wait(&barrier2);
That's in the main() and it was there so that the threads won't call
print_affinity() before main calls set_threadaffinity(). 		 	   		  
_________________________________________________________________
Your E-mail and More On-the-Go. Get Windows Live Hotmail Free.
https://signup.live.com/signup.aspx?id=60969