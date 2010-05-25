Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349Ab0EYVIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:08:38 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934328Ab0EYVIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:08:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oYUjv/7iu8y1zviUBa1siKn3qYTmkMqEcwwhmZR/EtJKtem1qncWNn59uMPvFzX1+
	X+wpXQLJTUZAAPA2R56sg==
MIME-Version: 1.0
In-Reply-To: <1274664671-27385-1-git-send-email-acme@infradead.org>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
Date: Tue, 25 May 2010 23:08:29 +0200
Message-ID: <AANLkTil5WtBnMQt1odjEgmWHOuuKxb4AIyuBLAqOiUSg@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] perf annotate fix and report improvoment
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 3:31 AM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Hi Ingo,
>
>        Please pull from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
>
> Regards,
>
> - Arnaldo
>
> Arnaldo Carvalho de Melo (2):
>  perf report: Support multiple events on the TUI
>  perf annotate: Fix up usage of the build id cache
>
With these patches, can I analyze a binary on a remote
machine? If I copy perf.data + .debug subdir, then can
I run perf annotate on a different machine, where I don't
have the sampled binaries installed?

I have tried that today using -tip, and perf annotate still
looked for the binary using its original pathname in perf.data.
perf report worked fine.

Thanks.

>  tools/perf/builtin-report.c |   60 +++++++++++++++++++++--------------
>  tools/perf/util/hist.c      |   13 ++++++-
>  tools/perf/util/hist.h      |   14 +++++++-
>  tools/perf/util/newt.c      |   74 ++++++++++++++++++++++++++++++++++--------
>  4 files changed, 119 insertions(+), 42 deletions(-)
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
