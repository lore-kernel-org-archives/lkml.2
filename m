Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab0JOQeC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:34:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61942 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab0JOQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:34:00 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=UspuWcHf5IAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=a_U1oVfrAAAA:8 a=4tX8S1DNGqvp3MOKkrEA:9 a=7TcJGOF4TaiXCOCRXL8A:7 a=g-351mv-z_zpYEGg8m0IR-jSD58A:4 a=PUjeQqilurYA:10 a=k4qQewaewV0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace-cmd: Plug startup race between flush_threads and
 recorders
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-trace-users@vger.kernel.org
In-Reply-To: <4CB8401B.2020801@siemens.com>
References: <4CB8401B.2020801@siemens.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 12:33:59 -0400
Message-ID: <1287160439.23682.67.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 13:50 +0200, Jan Kiszka wrote:
> As the SIGUSR1 handler is so far registered after forking the recorder
> child, there is a small race window where a flush sent by the main
> process can actually kill the child. Plug this by registering the signal
> handlers before the fork. This also allows to unify SIGINT registration.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

Applied, Thanks!

-- Steve


