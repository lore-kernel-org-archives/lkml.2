Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2LXF4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 00:56:21 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62261 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2LXF4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 00:56:18 -0500
MIME-Version: 1.0
In-Reply-To: <20121221145107.GA10213@ghostprotocols.net>
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
 <1356078018-31905-4-git-send-email-namhyung@kernel.org> <20121221145107.GA10213@ghostprotocols.net>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 24 Dec 2012 14:55:56 +0900
X-Google-Sender-Auth: qVluDJjbgB9VTwBg6YuhQs3_DKY
Message-ID: <CAM9d7ch3MgBoS_qXWDho38DWr+WYqCPpOpna1+w8PgnwjYrANg@mail.gmail.com>
Subject: Re: [PATCH 3/6] perf ui/gtk: Implement basic GTK2 annotation browser
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Merry Christmas!

On Fri, Dec 21, 2012 at 11:51 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Fri, Dec 21, 2012 at 05:20:15PM +0900, Namhyung Kim escreveu:
>> Basic implementation of perf annotate on GTK2.  Currently only
>> shows first symbol.
>
> I merged the first two patches in this series, but this one needs to be
> merged with the sixth patch, so that we can try it at this point, then
> you can add more features (patches 4 and 5) that can be tested as we
> merge them.

You can apply patch 6 before 4 and 5 since it's not depends on them.
But if you want, I'll resend a squashed patch for 3 + 6.


> Just pushed my perf/core branch with the 2 first patches.

Thanks a lot! :)

-- 
Thanks,
Namhyung
