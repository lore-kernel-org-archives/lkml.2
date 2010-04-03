Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0DCA6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 20:58:40 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:54264 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754465Ab0DCA6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 20:58:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANcptktGHnq6/2dsb2JhbACbS3KmSY1NhQUEhiU
Date: Fri, 2 Apr 2010 20:58:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RELEASE] LTTng 0.205, 0.206, ltt-control 0.82 for
	Linux 2.6.33.2
Message-ID: <20100403005834.GA28919@Krystal>
References: <20100403004457.GA5992@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100403004457.GA5992@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:55:55 up 8 days, 10:58,  4 users,  load average: 0.03, 0.07,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and LTTng 0.207 fixes an embarrassing build error introduced in
LTTng 0.206.

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Hi,
> 
> Here come the latest LTTng versions, bringing mostly bugfixes:
> 
> - LTTng 0.205 fixes a kref race in channel teardown vs lttd file open.
> - LTTng 0.206 marks Immediate Values as BROKEN for PowerPC. Will be replaced by
>   asm goto from mainline eventually anyway, so don't bother looking for the
>   cause of the bug.
> - ltt-control 0.82 ensures lttctl waits for lttd to complete when called at
>   trace destruction in overwrite mode. Failure to do so can result in unread
>   channels in flight recorder mode.
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
