Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0DTHhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 03:37:10 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39877 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0DTHhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 03:37:08 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       benh <benh@kernel.crashing.org>, Masami Hiramatsu <mhiramat@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4] perf: Split out arch specific code & improve PowerPC perf probe support
From: Ian Munsie <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
In-reply-to: <1271746713-8347-1-git-send-email-imunsie@au1.ibm.com>
References: <1271746713-8347-1-git-send-email-imunsie@au1.ibm.com>
Date: Tue, 20 Apr 2010 17:36:37 +1000
Message-Id: <1271748940-sup-3011@au1.ibm.com>
User-Agent: Sup/0.10.2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Ian Munsie's message of Tue Apr 20 16:58:31 +1000 2010:
> Here's the 4th version of the perf probe PowerPC support and perf arch specific
> infrastructure patches rebased on top of tip/perf/core.

That should read "rebased on top of tip/master".

Cheers,
-Ian
