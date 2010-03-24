Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab0CXRp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:45:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab0CXRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:45:27 -0400
X-Authority-Analysis: v=1.0 c=1 a=Ze_YP5u4wlQA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=-56AzMhhz4QhQPvifQIA:9 a=ecBX-IWpIwbXDNnZ_-oHZD__0fkA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] lockdep_init_map error in sysfs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <1269452592.2957.2852.camel@gandalf.stny.rr.com>
References: <1269452592.2957.2852.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 24 Mar 2010 13:45:25 -0400
Message-ID: <1269452725.2957.2856.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 13:43 -0400, Steven Rostedt wrote:
> I'm getting this in latest Linus tree:

Correction, the tree is not the latest. I'll try out the latest to see
if it still exists.

Thanks,

-- Steve

> 
> BUG: key ffff88002ede4870 not in .data!
> ------------[ cut here ]------------


