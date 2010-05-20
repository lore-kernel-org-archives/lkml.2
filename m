Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0ETJyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:54:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab0ETJyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:54:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=Vj7+58uQpSRsYgExZ0tKCpSuQoMKszaxxgpE3EPHdps4PQHwq+GEGwK+gn/9Em0OU
	NtpQFNgdAV25mPcQ03DCw==
MIME-Version: 1.0
In-Reply-To: <1274288493-15523-1-git-send-email-acme@infradead.org>
References: <1274288493-15523-1-git-send-email-acme@infradead.org>
Date: Thu, 20 May 2010 11:54:17 +0200
Message-ID: <AANLkTin1Lof5-907Afc24Ato1MqOE93uyxb-xx4XEYUg@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] perf session fix host_machine handling wrt build 
	ids
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

On Wed, May 19, 2010 at 7:01 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> [root@doppio linux-2.6-tip]#
> [root@doppio linux-2.6-tip]# perf archive
> Now please run:
>
> $ tar xvf perf.data.tar.bz2 -C ~/.debug
>
> wherever you need to run 'perf report' on.

Supposedly, on the remote machine with the perf.data +tarball files,
I should be able to run perf report, perf annotate.

I tried that. The perf report works but not perf annotate. It can't
find the binary image of my program. Yet there is a copy in the
.debug subdir. It seems, it is looking for the image using the
absolute file path in perf.data, instead.

Am I missing something here?
