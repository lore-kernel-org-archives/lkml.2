Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0CWRlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:41:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:52252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0CWRlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:41:40 -0400
Subject: Re: [PATCH] perf_events: fix remapped count support
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4ba8f988.9804cc0a.4b1f.5d77@mx.google.com>
References: <4ba8f988.9804cc0a.4b1f.5d77@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 18:41:27 +0100
Message-ID: <1269366087.5109.143.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 18:25 +0200, Stephane Eranian wrote:
>         This patch fixes the remapped counter support such that it now works
>         on X86 processors.

(could you please not add all this whitespace in front? and make sure
 it's no wider than 70 chars)

Also, I wouldn't say it fixes it, it's currently not broken, its plain
not implemented. So this patch adds support for rdpmc.

>         For other architectures, e.g., PPC, SPARC, assuming they do offer the ability
>         to read counts directly from user space, all that is needed is a couple of new
>         arch specific functions:

Power already supports this, so if you just broke this Paul is going to
be unhappy.
