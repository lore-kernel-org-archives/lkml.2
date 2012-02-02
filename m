Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2BBQdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:33:15 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57990 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755150Ab2BBQdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:33:13 -0500
Message-ID: <4F2ABAC6.5060200@gmail.com>
Date: Thu, 02 Feb 2012 09:33:10 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jean-Michel Hautbois <jhautbois@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Specifying some processes to record using perf
References: <CAL8zT=gX5=S9fd1MdYyYVYg+35anmK-aJwFj9fUiKNuMSb8n_w@mail.gmail.com> <CAL8zT=jXmSWbEQO2T2Kpp2_Yei5VJ+sGVt5U2vJwPo=6T2YY1g@mail.gmail.com>
In-Reply-To: <CAL8zT=jXmSWbEQO2T2Kpp2_Yei5VJ+sGVt5U2vJwPo=6T2YY1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/02/2012 08:52 AM, Jean-Michel Hautbois wrote:
> Hi all,
> 
> I am using perf and I have several process and threads to record.
> I know that some threads in particular are interesting, and I don't
> find a way to specify multiple threads in perf record.
> The "-t" option takes only one thread IIUC.
> I don't know if the "--cgroup" is intended to do that, but I didn't
> succeed to use it...
> 
> I would also like to exclude one specific process (or thread) when I
> do a system-wide record, and I think it is not possible either ?
> 
> Thanks in advance !
> Regards,
> JM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Right now pef-record can only do only 1 process or 1 thread. I started
working on a patch to support multiple of both (e.g., allow multiple -t
or -p arguments), but I have not finished it.

Other options: Arnaldo recently added a uid option or you can record for
all processes and filter the output to just your processes/threads of
interest.

David
