Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab0EDSgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:36:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44010 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760063Ab0EDSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Tg5qcU5g1oRU+hFlt2Rs33BRqz6ygLi4cY25NxJjyTfI91kR0ykyY3jqIoMwcnF851
         mKtZ6wH32BcbYs06XvVX7LL/XFOHWklHf2yUBIb2Uo404oE5GP/OU1gn06Di9JsW/jcH
         XxerAiGGZPeNv+NcxdKBk816SszyouHLzvMlk=
Message-ID: <4BE06933.9080202@lwfinger.net>
Date: Tue, 04 May 2010 13:36:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: How to write marker info in MMIO trace from kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

I hope you are the correct person for this question.

I would like to write information into the MMIO trace file similar to
what the user space write to /sys/.../trace_marker would accomplish,
however, I want to do it in place of printk statements in the driver I'm
tracing. Do you have any suggestions on how to do this? I have tools to
merge the trace dump with dmesg output, but the latter lags behind and I
do not get good correlation.

Thanks,

Larry
