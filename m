Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2ITTRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:17:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50204 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2ITTRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120914054043.GA9043@gmail.com>
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
 <1347574063-22521-3-git-send-email-irina.tirdea@intel.com> <20120914054043.GA9043@gmail.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Thu, 20 Sep 2012 22:17:33 +0300
Message-ID: <CANg8OW+mk_RSs9dYMmmencaRdrQATVnitiauEPv8rnRFnVj1wA@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf stat: add compile-time option to disable --big-num
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 8:40 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Irina Tirdea <irina.tirdea@gmail.com> wrote:
>
>> From: Irina Tirdea <irina.tirdea@intel.com>
>>
>> In printf's format, ' is used to group the output with thousands' grouping
>> characters for decimal conversion. Bionic does not support ' for printf.
>
> Please try to solve compatibility without affecting the default
> output and big num is the default perf stat output.

Understood.

> Could the big num output be implemented within perf, without
> relying on glibc's printf implementation?
>

Yes. I'll write a function that does the grouping instead of using
printf and send it for review instead of this patch.

Thanks,
Irina
