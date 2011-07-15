Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1GOFai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:30:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63779 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab1GOFah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <1310707962.18875.349.camel@minggr.sh.intel.com>
References: <1310707962.18875.349.camel@minggr.sh.intel.com>
Date: Fri, 15 Jul 2011 13:30:37 +0800
Message-ID: <CAM_iQpWrpY456YuHeR3QuLj_5FoFFgoOfNwGRqagwjiZKga7Gg@mail.gmail.com>
Subject: Re: [PATCH] ftrace: Fix building warning with !CONFIG_FUNCTION_TRACER
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 1:32 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Commit 43dd61c(ftrace: Fix regression of :mod:module function enabling)
> causes below warning because ‘struct ftrace_hash’ is not declared with
> !CONFIG_FUNCTION_TRACER.

It is fixed,
https://lkml.org/lkml/2011/7/14/390
