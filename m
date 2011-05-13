Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1EMPfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:35:38 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:65066 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab1EMPfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xl+pOsupDSvbIw78TkmI+br/gJAo3WxFxwnNZhUq30qxcpp7/57yYwvaQunlm7vDru
         F/mkVas7uiN1Y0GZdjzOwVx/4VutQQx5rcms+CqDQVjSkuVW/6QO7bifZy+t+64B2ypT
         3hzNLTtrvEDM71e2kDSAdyAoJ9CgZG8k+Y09c=
Message-ID: <4DCD4FC5.8020608@gmail.com>
Date: Fri, 13 May 2011 09:35:33 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110421 Fedora/3.1.9-2.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wim Heirman <wim@heirman.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf-stat per thread results
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
In-Reply-To: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/13/11 09:14, Wim Heirman wrote:
> Hi all,
> 
> I'm using perf-stat to look at hardware performance counters for a
> parallel program. Is there a way to get counter values for each thread
> individually, rather than aggregated for the whole process? I know I
> can attach to a specific thread using --tid=, but due to the time
> required to find the tid and attach/detach this isn't accurate for
> short-running programs.

perf-stat requires changes to dump counters per thread; it currently
sums all threads into a single value.

> Or, alternatively, can I use perf record --stat and get an exact count
> for each performance counter?

perf-record does not read values from hardware counters.

David



> 
> Thanks,
> Wim Heirman
> Ghent University, Belgium
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
