Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab1BOPBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:01:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48186 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1BOPBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=B3QMJARgXLWtcFmc98LJSyixCCzml6XF5s9cw5dpR+DB098jztf/gp1UkNOnsKVnVp
         ElyGT/QywU90XsnzTiUS5bRHBIix9D32mycn1PndQT2cF/cZWlv66/yYEqw8E9kDID2h
         IzhR2zy47l7PTPAG9pFXlFjRbrymqxuKkp+mo=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1297781710.2413.17.camel@twins>
References: <4d590250.114ddf0a.689e.4482@mx.google.com>
	<1297781710.2413.17.camel@twins>
Date: Tue, 15 Feb 2011 16:01:09 +0100
Message-ID: <AANLkTin6oeDreACiYZfGnLFx8gjK1Qqd_6Mtp3ZHG+b7@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v9)
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1FF1Ms6021924

On Tue, Feb 15, 2011 at 3:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-02-14 at 11:20 +0200, Stephane Eranian wrote:
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if (mode & PERF_CGROUP_SWOUT) {
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  cpu_ctx_sched_out(cpuctx, EVENT_ALL);
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  /*
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â * must not be done before ctxswout dur
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â * to event_filter_match() in event_sched_out()
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â */
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  cpuctx->cgrp = NULL;
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  }
>
> s/dur/due/ ?
>
Yep, sorry about that.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
