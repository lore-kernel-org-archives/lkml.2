Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2GPQbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:31:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21655 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2GPQbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:31:12 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=wom5GMh1gUkA:10 a=-wGngUE2Vx8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=TIp0S-31sd-5K89FhOkA:9 a=CjuIK1q_8ugA:10 a=vmaUgIjkfsHwvPg9:21 a=_JFxb-S8fIMDP1yL:21 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Date: Mon, 16 Jul 2012 12:31:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        RT-users <linux-rt-users@vger.kernel.org>
Subject: Re: [patch RT 0/3] Stable rt updates - part II
Message-ID: <20120716163109.GB16873@home.goodmis.org>
References: <20120715090141.942753287@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120715090141.942753287@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 08:07:43AM -0000, Thomas Gleixner wrote:
> Steven,
> 
> please pick the following three patches which address the CPU hotplug
> nightmare on RT.
> 
> I still hate them, but we want to have that addressed in the stable
> series.
> 

BTW, they are missing the From line. Unless you want to take credit for
these ugly hacks, I should probably add them in.

-- Steve

