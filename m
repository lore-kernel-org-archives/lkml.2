Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439Ab1IKVwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 17:52:46 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43995 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754734Ab1IKVwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 17:52:45 -0400
Date: Sun, 11 Sep 2011 17:52:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Michael Elizabeth Chastain <mec@shout.net>, linux-kernel@vger.kernel.org
Cc: ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH 3.1] ioctl: register LTTng ioctl
Message-ID: <20110911215244.GC2275@Krystal>
References: <20110911214940.GA2275@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911214940.GA2275@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:51:46 up 292 days,  2:54,  4 users,  load average: 0.05, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> The LTTng 2.0 kernel tracer (stand-alone module package, available at
> http://lttng.org) uses the 0xF6 ioctl range for tracer control and
> transport operations.

According to my SMTP server, mec@shout.net does not seem to exist at the
moment. Will resend to a different recipient.

Best regards,

Mathieu

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Michael Elizabeth Chastain <mec@shout.net>
> ---
>  Documentation/ioctl/ioctl-number.txt |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux/Documentation/ioctl/ioctl-number.txt
> ===================================================================
> --- linux.orig/Documentation/ioctl/ioctl-number.txt
> +++ linux/Documentation/ioctl/ioctl-number.txt
> @@ -319,4 +319,6 @@ Code  Seq#(hex)	Include File		Comments
>  					<mailto:thomas@winischhofer.net>
>  0xF4	00-1F	video/mbxfb.h		mbxfb
>  					<mailto:raph@8d.com>
> +0xF6	all	LTTng			Linux Trace Toolkit Next Generation
> +					<mailto:mathieu.desnoyers@efficios.com>
>  0xFD	all	linux/dm-ioctl.h
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
