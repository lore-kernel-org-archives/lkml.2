Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0JUIZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:25:43 -0400
Received: from [120.204.251.227] ([120.204.251.227]:33472 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752901Ab0JUIZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:25:42 -0400
Subject: Re: Ftrace: can trace kthread?
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
References: <1287647732.2237.7.camel@myhost>
	 <AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 16:21:23 +0800
Message-ID: <1287649283.2237.8.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2010 08:25:23.0459 (UTC) FILETIME=[81A76530:01CB70F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 16:10 +0800, Yong Zhang wrote:
> On Thu, Oct 21, 2010 at 3:55 PM, Figo.zhang
> <zhangtianfei@leadcoretech.com> wrote:
> > hi,
> >
> > is it ftrace in 2.6.36-rc8 can trace the kthread?
> 
> How about the set_ftrace_pid interface?
> 

i try by set_ftrace_pid, it also can't ftrace the kswapd.

