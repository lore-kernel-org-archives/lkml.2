Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2FHG7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:59:16 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36043 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2FHG7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FD1A26B.7010601@gmail.com>
References: <20120507121527.GA19526@lizard>
	<4FA82056.2070706@gmail.com>
	<CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
	<CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
	<CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
	<CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<20120601122118.GA6128@lizard>
	<alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
	<4FCC7592.9030403@kernel.org>
	<20120604113811.GA4291@lizard>
	<4FCD14F1.1030105@gmail.com>
	<CAOJsxLGbX33TfGvMEzV4By=n8JojHcXV32FRueb3kmti38jBPQ@mail.gmail.com>
	<4FD177BD.1070004@gmail.com>
	<CAOJsxLGHDF_QnRSA_CckdTDGxNkOFvRNZoFoW0iGDjGvTCK=2A@mail.gmail.com>
	<4FD1A26B.7010601@gmail.com>
Date: Fri, 8 Jun 2012 09:59:13 +0300
X-Google-Sender-Auth: 0HZpoqZVTAk3CQkSsph69VLYseo
Message-ID: <CAOJsxLEEssrFBC46ayh9Qx1Qm69iXBAKjNDj+S+AWCOzWP4Csg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Some vmevent fixes...
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 9:57 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> Guys, current vmevent _is_ a polling interface. It only is wrapped kernel
> timer.

Current implementation is like that but we don't intend to keep it
that way. That's why having a separate ABI is so important.
