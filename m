Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab0LGGnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:43:04 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42219 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0LGGnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:43:02 -0500
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf: Allow strong and weak functions in LIB_OBJS
From: Ian Munsie <imunsie@au1.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-reply-to: <1290991642-sup-5890@au1.ibm.com>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com> <1290658375-10342-2-git-send-email-imunsie@au1.ibm.com> <20101126211836.GA5864@ghostprotocols.net> <1290991642-sup-5890@au1.ibm.com>
Date: Tue, 07 Dec 2010 17:42:58 +1100
Message-Id: <1291704103-sup-9818@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Ian Munsie's message of Mon Nov 29 11:53:07 +1100 2010:
> I'm not seeing any of those warnings or errors on either of the systems
> I have been testing on (x86_64 + PPC64), but it looks like the linker is
> trying to pull in too much from the system libraries.
> 
> Can you test the below patch to see if the messages go away - it only
> applies the whole-archive flag to libperf.a, whereas before I was also
> applying it to pthread, libelf, etc.

Hey Arnaldo,

Just wondering if you got around to testing this patch?

Thanks,
-Ian
