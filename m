Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2FHG5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:57:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48286 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2FHG5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:57:11 -0400
MIME-Version: 1.0
In-Reply-To: <4FD17564.9060209@gmail.com>
References: <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
	<CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
	<CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
	<CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<20120601122118.GA6128@lizard>
	<alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
	<4FCC7592.9030403@kernel.org>
	<20120604113811.GA4291@lizard>
	<4FCD14F1.1030105@gmail.com>
	<20120604223951.GA20591@lizard>
	<4FD17564.9060209@gmail.com>
Date: Fri, 8 Jun 2012 09:57:09 +0300
X-Google-Sender-Auth: pruK5gK_BEso5kMHD9yMJso2odI
Message-ID: <CAOJsxLEeHR8MLAGteN_noU9Ncc+Q4eMVhQO7yDwxLQTTXrjJog@mail.gmail.com>
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

On Fri, Jun 8, 2012 at 6:45 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> So, big design choice here. 1) vmevent is a just notification. it can't
> guarantee to prevent oom. or 2) to implement some trick (e.g. reserved
> memory for vmevent processes, kernel activity blocking until finish
> memory returing, etc)

Yes, vmevent is only for notification and will not *guarantee* OOM
prevention. It simply tries to provide hints early enough to the
userspace to so that OOM can be avoided if possible.
