Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab1DMTs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:48:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758Ab1DMTs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:48:56 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=NB8ymUw9eYgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=SwXSiE8MJ60MRasKHagA:9 a=f_0q0LeDm6EKbt--JacA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Permission to relicense Tracepoint/TRACE_EVENT code to LGPL
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
In-Reply-To: <20110413175048.GA28738@Krystal>
References: <20110413175048.GA28738@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 15:48:49 -0400
Message-ID: <1302724129.13584.1.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 13:50 -0400, Mathieu Desnoyers wrote:
> Hi Steven,
> 
> Just to make it official, can I get your permission to relicense code in
> commit
> 
> commit 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Apr 20 17:04:50 2010 -0400
> 
> Which adds "NOARGS" support to tracepoints to LGPL ?
> 
> As we discussed, are you willing to give your permission for LGPL
> relicensing your future contributions to Tracepoints and TRACE_EVENT?

LGPLv2.1 (not later)

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

