Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1JEEIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:08:24 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33508 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1JEEIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:08:23 -0400
X-AuditID: b753bd60-9f8a3ba000005c89-f5-4e8bd83488fd
X-AuditID: b753bd60-9f8a3ba000005c89-f5-4e8bd83488fd
Message-ID: <4E8BD821.1020604@hitachi.com>
Date: Wed, 05 Oct 2011 13:08:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/4] [TRIVIAL] ftrace/kprobes: Fix an warning typo
References: <20111004104438.14591.6553.stgit@fedora15>            <20111004104449.14591.16995.stgit@fedora15> <14310.1317743883@turing-police.cc.vt.edu>
In-Reply-To: <14310.1317743883@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/05 0:58), Valdis.Kletnieks@vt.edu wrote:
> On Tue, 04 Oct 2011 19:44:49 +0900, Masami Hiramatsu said:
>> Add a space between words.
> 
>>  		if (ret == -ENOENT && trace_probe_is_on_module(tp)) {
>> -			pr_warning("This probe might be able to register after"
>> +			pr_warning("This probe might be able to register after "
>>  				   "target module is loaded. Continue.\n");
> 
> Better would be to make it all one line.  Keeping a string together trumps the
> 80-column rule.
> 

Agreed :) I'd like to check whether other messages should be fixed too.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
