Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422749Ab2JDP3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:29:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26683 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422644Ab2JDP3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:29:49 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=T5v1fc8_-g4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=YIIzJC-knJ0A:10 a=VwQbUJbxAAAA:8 a=VZOVyJ9ujMy8BWwVoj4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349364584.6755.20.camel@gandalf.local.home>
Subject: Re: [PATCH RT] softirq: Init softirq local lock after per cpu
 section is set up
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable-rt@vger.kernel.org
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Carsten Emde <cbe@osadl.org>, vomlehn@texas.net
Date: Thu, 04 Oct 2012 11:29:44 -0400
In-Reply-To: <1349362924.6755.18.camel@gandalf.local.home>
References: <1349362924.6755.18.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 11:02 -0400, Steven Rostedt wrote:

> By moving the softirq_early_init() right after setup_per_cpu_areas(),
> the kernel boots fine.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 

Bah, I forgot to Cc stable-rt.

Cc: stable-rt@vger.kernel.org

-- Steve


