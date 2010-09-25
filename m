Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0IYSN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:13:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab0IYSN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:13:58 -0400
X-Authority-Analysis: v=1.1 cv=Yii9LXZpONf3Dl4H+sCjsa4WyoNNo7yi1hAau1xJxWE= c=1 sm=0 a=PMz3Skcm1w0A:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=VnNF1IyMAAAA:8 a=Q74mnooV4EfND6O_7DIA:9 a=Re4ZbZEN4cfsPBMsn0DMnZOYeBUA:4 a=CjuIK1q_8ugA:10 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Sat, 25 Sep 2010 13:19:28 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Shailabh Nagar <nagar1234@in.ibm.com>, linux-s390@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Venkatesh Pallipadi <venki@google.com>,
        John stultz <johnstul@us.ibm.com>,
        containers@lists.linux-foundation.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, holzheu@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise
 accounting
Message-ID: <20100925181928.GA19611@hallyn.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
 <20100923131136.356075f4.akpm@linux-foundation.org>
 <20100923221139.GI23839@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923221139.GI23839@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matt Helsley (matthltc@us.ibm.com):
> I don't think even "root" can see/use pids outside its namespace (without

Just to be clear on this, you're right in what you say, but if a task in a child
pidns still has access to the /proc mount of the parent pidns, then it can see
the pids in there, and get information from them, i.e. /proc/pid/maps.  So
in that sense, some people could misinterpret "see/use pids" and think you
weren't right.

-serge
