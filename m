Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2GYJNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:13:18 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57225 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GYJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:13:17 -0400
X-AuditID: b753bd60-914c2ba0000047ca-f6-500fb8a9f267
X-AuditID: b753bd60-914c2ba0000047ca-f6-500fb8a9f267
Message-ID: <500FB8A4.6060503@hitachi.com>
Date: Wed, 25 Jul 2012 18:13:08 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, qemu-devel@nongnu.org,
        Borislav Petkov <bp@amd64.org>,
        virtualization@lists.linux-foundation.org,
        "Franch Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: Re: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp> <CAJSP0QW_2JJ0nf=NW0y30VSid2HSxaqb=mRGV8CTtAKj0ujDWw@mail.gmail.com> <500E810A.4030309@hitachi.com> <500E84D7.7060103@hitachi.com> <CAJSP0QVuQnE68n=jyW+AE=WF3yDHjgdn7tdiz7rPTbtqGYFL4w@mail.gmail.com>
In-Reply-To: <CAJSP0QVuQnE68n=jyW+AE=WF3yDHjgdn7tdiz7rPTbtqGYFL4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

(2012/07/24 22:41), Stefan Hajnoczi wrote:
> On Tue, Jul 24, 2012 at 12:19 PM, Yoshihiro YUNOMAE
> <yoshihiro.yunomae.ez@hitachi.com> wrote:
>>>> Are you using text formatted ftrace?
>> No, currently using raw format, but　we'd like to reformat it in text.
>
> Capturing the info necessary to translate numbers into symbols is one
> of the problems of host<->guest tracing so I'm curious how you handle
> this :).

Right, your consideration is true.

> Apologies for my lack of ftrace knowledge but how useful is the raw
> tracing data on the host?  How do you pretty-print it in
> human-readable form?

perf and trace-cmd can actually translate raw-formatted trace data to
text-formatted trace data by using information of kernel or trace
format under tracing/events directory in debugfs. In the same way, if
the information of a guest is exported to a host, we can translate
raw trace data of a guest to text trace data on a host. We will use
9pfs to export that.

Thank you,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


