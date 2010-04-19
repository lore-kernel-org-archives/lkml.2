Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0DSOLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:11:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44691 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0DSOLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:11:32 -0400
X-Authority-Analysis: v=1.1 cv=4zru/oO1PQpEm2SyzJWQB8cs3WBzsLhxb1x/U/RGpxE= c=1 sm=0 a=5x1e3oJTu68A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=bucaaORKq-2yhLC1i7AA:9 a=v88k6xO7gjt6N9E1mMHgmyZLuQkA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] Fix inappropriate substraction on
 tracing_pages_allocated in  trace_free_page()in 2.6.27.y series kernel
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: shenghui <crosslonelyover@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <m2i5a774f4c1004102223zbfc0ce63u4e8682b69e7d8088@mail.gmail.com>
References: <m2i5a774f4c1004102223zbfc0ce63u4e8682b69e7d8088@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 10:11:28 -0400
Message-ID: <1271686289.19685.31805.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-11 at 13:23 +0800, shenghui wrote:
> I noticed inappropriate substraction on variable
> tracing_pages_allocated in trace_free_page()in 2.6.27.y series (from
> 2.6.27 to 2.6.27.46) kernel.
> 

I'm not maintaining a 2.6.27 kernel, but if someone else is, then feel
free to include this.

-- Steve


