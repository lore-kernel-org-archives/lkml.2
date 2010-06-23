Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0FWH0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:26:00 -0400
Received: from col0-omc1-s7.col0.hotmail.com ([65.55.34.17]:18579 "EHLO
	col0-omc1-s7.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678Ab0FWHZ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:25:59 -0400
Message-ID: <COL124-W189E570304D133AA8B8ECD6C50@phx.gbl>
X-Originating-IP: [178.128.47.180]
From: =?iso-8859-7?B?wevd7uHt5PHv8iDQ4fDh5O/j6eHt7dzq5/I=?= 
	<psxlover@hotmail.com>
To: <akpm@linux-foundation.org>
Subject: RE: sched_setaffinity not working with kernel 2.6.32.15
Date: Wed, 23 Jun 2010 10:25:58 +0300
Importance: Normal
In-Reply-To: <20100622171622.fc9d04c1.akpm@linux-foundation.org>
References: <COL124-W1850C30E9FF3BFB06DF5BFD6C20@phx.gbl>,<20100622171622.fc9d04c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Jun 2010 07:25:58.0971 (UTC) FILETIME=[537BB0B0:01CB12A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And:
if(pthread_barrier_init(&barrier2, NULL, NR_THREADS)) {
should be:
if(pthread_barrier_init(&barrier2, NULL, NR_THREADS+1)) {
 		 	   		  
_________________________________________________________________
Your E-mail and More On-the-Go. Get Windows Live Hotmail Free.
https://signup.live.com/signup.aspx?id=60969