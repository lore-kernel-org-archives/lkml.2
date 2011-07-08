Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1GHMQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:16:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1GHMQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:16:48 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=kDVWwySFN5wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=n8i27M1mAAAA:8 a=meVymXHHAAAA:8 a=ENI9SflM47Ad4Mv9LvoA:9 a=PUjeQqilurYA:10 a=rXZLD9m7qZoA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/1] plist: remove the need to supply locks to plist
 heads
From: Steven Rostedt <rostedt@goodmis.org>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1310084879-10351-2-git-send-email-dima@android.com>
References: <1310084879-10351-1-git-send-email-dima@android.com>
	 <1310084879-10351-2-git-send-email-dima@android.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 08 Jul 2011 08:16:44 -0400
Message-ID: <1310127404.26417.218.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 17:27 -0700, Dima Zavin wrote:
> This was legacy code brought over from the RT tree and
> is no longer necessary.
> 
> Signed-off-by: Dima Zavin <dima@android.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


