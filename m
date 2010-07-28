Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0G1Jt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:49:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33468 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0G1Jtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cfyCtD1bU9z0AUUcWx1sTlgTd/eJDooaVckaXFuG16HLiDgKCv/rYN9BS1HuKgczp8
         zzN+OoluQ+eY6krjRfhROcn+cf3q7m1/U8c8OA70IWk/HpRC96xilodEVEYvYPylEkBw
         0i67PK+1BaAZJbZoCTKJdp3ZOzCaZ6KGNUmuE=
MIME-Version: 1.0
Date: Wed, 28 Jul 2010 15:19:53 +0530
Message-ID: <AANLkTin1qWT=NykGs6_YMopxdWoLzOKa1Zg_Q9EbtY0b@mail.gmail.com>
Subject: No definition of trace_sched_stat_wait in kernel found!
From: Jack Daniel <wanders.thirst@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

With reference to the function update_stats_wait_end(), there seems to
be a call to trace_sched_stat_wait(). But strangely I can find no
definition of this function even though the kernel compiles without
any errors. There is no reference to this function
trace_sched_stat_wait() in the System.map file either, which means
this is not getting compiled? Could someone please make sense of this
absurdity.

Thanks,
Jack
