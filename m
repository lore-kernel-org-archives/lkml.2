Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2IBT6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 15:58:24 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49573 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2IBT6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 15:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <503E411D.2040406@gmail.com>
References: <CANg8OWJTKWnk=qx+rud3ypdbNFr=-B2Tp_j5_Ud-Z6S4vd_rwg@mail.gmail.com>
 <503E411D.2040406@gmail.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Sun, 2 Sep 2012 22:58:02 +0300
Message-ID: <CANg8OWKK7dgc46ddaZddhJGeTT_GWS7Swn2czTsrk+yP65tM1g@mail.gmail.com>
Subject: Re: [PATCH 03/13] perf tools: drop asm/byteorder.h wrapper
To: David Ahern <dsahern@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This https://lkml.org/lkml/2012/8/29/150 should fix the netinet/tcp.h build
> problem.
>

Thanks! Removing the header files is a much cleaner solution. I will
remove this patch and use yours.

Irina
