Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab0DHQPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:15:50 -0400
Received: from mx1.gb1.humyo.com ([62.44.71.171]:58253 "EHLO mx1.gb1.humyo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab0DHQPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:15:48 -0400
Message-ID: <4BBE01CB.9020701@humyo.com>
Date: Thu, 08 Apr 2010 17:18:19 +0100
From: John Berthels <john@humyo.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, Nick Gregory <nick@humyo.com>,
       Rob Sanderson <rob@humyo.com>, xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks, heavy
 write load, 8k stack, x86-64
References: <4BBC6719.7080304@humyo.com> <20100407140523.GJ11036@dastard> <4BBCAB57.3000106@humyo.com> <20100407234341.GK11036@dastard> <20100408030347.GM11036@dastard> <4BBDC92D.8060503@humyo.com> <4BBDEC9A.9070903@humyo.com>
In-Reply-To: <4BBDEC9A.9070903@humyo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Berthels wrote:
> John Berthels wrote:
>> I'll reply again after it's been running long enough to draw 
>> conclusions.
The box with patch+THREAD_ORDER 1+LOCKDEP went down (with no further 
logging retrievable by /var/log/messages or netconsole).

We're loading up a 2.6.33.2 + patch + THREAD_ORDER 2 (no LOCKDEP) to get 
better info as to whether we are still blowing the 8k limit with the 
patch in place.

jb

