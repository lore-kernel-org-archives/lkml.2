Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab1DYCfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 22:35:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44666 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab1DYCfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 22:35:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [PATCH] trace: Add tracepoints to fs subsystem
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Jiaying Zhang <jiayingz@google.com>
In-Reply-To: <1303513209-26436-1-git-send-email-vnagarnaik@google.com>
References: <1303513209-26436-1-git-send-email-vnagarnaik@google.com>
Message-Id: <20110425113723.2666.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 11:35:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jiaying Zhang <jiayingz@google.com>
> 
> Many fs tracepoints can now be traced via ftrace, however there are a
> few other tracepoints needed. This patch adds entry and exit tracepoints
> for a few additional functions, viz.:
> wait_on_buffer
> block_write_full_page
> mpage_readpages
> file_read

Zero background description?




