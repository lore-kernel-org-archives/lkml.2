Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0DXQOD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 12:14:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab0DXQOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 12:14:00 -0400
Message-ID: <4BD31891.6080508@redhat.com>
Date: Sat, 24 Apr 2010 12:13:05 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 8/9] perf: Add a perf trace option to check samples ordering
 reliability
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com> <1272074742-3654-9-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1272074742-3654-9-git-send-regression-fweisbec@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Frederic Weisbecker wrote:
> To ensure sample events time reordering is reliable, add a -d option
> to perf trace to check that automatically.

Just out of curiosity, is there any possibility to add 
other debugging options to perf-trace?
If so, I think we can pass some arguments for
this -d option, e.g. "-d ordering,events" and so on.
Just an idea.

Thank you,



-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
