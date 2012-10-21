Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2JUIT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 04:19:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65286 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2JUITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 04:19:54 -0400
Message-ID: <5083B026.1030307@gmail.com>
Date: Sun, 21 Oct 2012 16:19:50 +0800
From: caiyuqing <yuqingcaik@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: question about context switch on arm Linux
References: <50839002.8020305@gmail.com> <20121021074434.GB4735@netboy.at.omicron.at>
In-Reply-To: <20121021074434.GB4735@netboy.at.omicron.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年10月21日 15:44, Richard Cochran 写道:
> On Sun, Oct 21, 2012 at 02:02:42PM +0800, caiyuqing wrote:
>> hi, all.
>> I have some questions about context switch on arm Linux (my target is
>> ARMv7-a).
>> 1. Does arm linux support FCSE to handle the context switch?
> No, mainline Linux does not support FCSE. However, you can use Gilles'
> unoffical (but working) FCSE branches at
>
>    http://git.xenomai.org/?p=ipipe-gch.git;a=summary
>
>> 2. If using FCSE, that means the processes number limit is 128 and the
>> memory limit is 32MB per process, is that right?
> Yes and no.
>
> Gilles' patches offer a "strict mode" and a "best effort" mode. The
> strict mode does have the limitation, but the best effort mode does
> not.
>
> HTH,
> Richard
Richard, thanks for your reply.
mainline Linux doesn't support FCSE, if so, when kernel switch a process 
to another(these two process share the same virtual memory space), that 
means the vitrual-to-physical address should be remaped, TLB shuold be 
invalid, CACHE should be flushed, right?

qing





