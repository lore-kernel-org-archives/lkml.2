Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2DQEoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 00:44:09 -0400
Received: from [124.207.24.138] ([124.207.24.138]:51011 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2DQEoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 00:44:08 -0400
MIME-Version: 1.0
In-Reply-To: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
Date: Tue, 17 Apr 2012 12:43:28 +0800
Message-ID: <CAF1ivSZpcrCt3_cJWZLu7f7Z-DMGhijO4gM+2MTLNQC1p8=A7g@mail.gmail.com>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Lin Ming <mlin@ss.pku.edu.cn>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 4:07 PM, Tu, Xiaobing <xiaobing.tu@intel.com> wrote:
> From: xiaobing tu <xiaobing.tu@intel.com>
>
> Here is the kernel patch for this tool, The idea is to output user space stack call-chain from /proc/xxx/stack, currently, /proc/xxx/stack only output kernel stack call chain. We extend it to output user space call chain in hex format

The log is too long on a single line.
You should split it to multiple lines.

Lin Ming
