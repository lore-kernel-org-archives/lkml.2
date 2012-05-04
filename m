Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab2EDBqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 21:46:10 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42628 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2EDBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 21:46:08 -0400
X-AuditID: 9c930197-b7badae000000cfd-bb-4fa334dc67ec
From: Namhyung Kim <namhyung.kim@lge.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Arnaud Lacombe <lacombar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: perf build failure on Linus's tree
References: <20120503215748.GA18995@kroah.com>
	<87sjfgafqj.fsf@sejong.aot.lge.com> <20120504014120.GA9005@kroah.com>
Date: Fri, 04 May 2012 10:45:04 +0900
In-Reply-To: <20120504014120.GA9005@kroah.com> (Greg KH's message of "Thu, 3
	May 2012 18:41:20 -0700")
Message-ID: <87obq4afdr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 3 May 2012 18:41:20 -0700, Greg KH wrote:
> On Fri, May 04, 2012 at 10:37:24AM +0900, Namhyung Kim wrote:
>> What are versions of tools you are using?
>
> gcc 4.6.2 from openSUSE 12.1.
> Any other tools you want to know the version of?

flex and bison versions might be helpful.

Thanks,
Namhyung
