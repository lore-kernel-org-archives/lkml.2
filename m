Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1KUPqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:46:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59584 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1KUPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:46:08 -0500
Message-ID: <4ECA723B.9090200@gmail.com>
Date: Mon, 21 Nov 2011 08:46:03 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf script: Add comm filtering option
References: <1321641585-5643-1-git-send-email-dsahern@gmail.com> <20111121125831.GA2325@ghostprotocols.net>
In-Reply-To: <20111121125831.GA2325@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/21/2011 05:58 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 18, 2011 at 11:39:45AM -0700, David Ahern escreveu:
>> Allows collecting events system wide and then pulling out events
>> for a specific task name(s). e.g,
>>
>>     perf script -c gnome-shell,gnome-terminal
>>
>> Applies on top of:
>>     https://lkml.org/lkml/2011/11/13/74
> 
> Can't we just reuse symbol_conf.comm_list[_str]?
>  
> - Arnaldo

For now, yes. I'll redo.

David
