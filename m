Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab2ARErf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:47:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2AREre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:47:34 -0500
Message-ID: <4F164EE0.1000507@gmail.com>
Date: Tue, 17 Jan 2012 21:47:28 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v4 1/5] perf-script: unify the expressions indicate
 "unknown"
References: <20120116052146.2485.48349.stgit@linux3> <20120116052210.2485.80894.stgit@linux3> <20120117154902.GA15820@infradead.org> <4F164DDA.1040507@hitachi.com>
In-Reply-To: <4F164DDA.1040507@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 09:43 PM, Akihiro Nagai wrote:
> I see. I'm going to fix and resend my patches,
> e.g. map__print_dsoname(self) => map__fprintf_dsoname(map, fp)

If you are going to redo the patch set I have one request: change the
name of the offset field (currently offs in your patch) to symoff to
mean offset for the symbol name versus offset in the DSO. It's the
latter that I use locally, so symoff would allow both to coexist.

Thanks,

David
