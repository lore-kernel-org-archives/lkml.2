Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2GZKwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:52:11 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47747 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762Ab2GZKwK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <500FB8A4.6060503@hitachi.com>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
	<CAJSP0QW_2JJ0nf=NW0y30VSid2HSxaqb=mRGV8CTtAKj0ujDWw@mail.gmail.com>
	<500E810A.4030309@hitachi.com>
	<500E84D7.7060103@hitachi.com>
	<CAJSP0QVuQnE68n=jyW+AE=WF3yDHjgdn7tdiz7rPTbtqGYFL4w@mail.gmail.com>
	<500FB8A4.6060503@hitachi.com>
Date: Thu, 26 Jul 2012 11:52:09 +0100
Message-ID: <CAJSP0QUJkZrMMU6_OZsX7jCCnikvYmmPKkQui=qsdYxWTz1xCw@mail.gmail.com>
Subject: Re: Re: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 10:13 AM, Yoshihiro YUNOMAE
<yoshihiro.yunomae.ez@hitachi.com> wrote:
> Hi Stefan,
>
>
> (2012/07/24 22:41), Stefan Hajnoczi wrote:
>>
>> On Tue, Jul 24, 2012 at 12:19 PM, Yoshihiro YUNOMAE
>> <yoshihiro.yunomae.ez@hitachi.com> wrote:
>>>>>
>>>>> Are you using text formatted ftrace?
>>>
>>> No, currently using raw format, but　we'd like to reformat it in text.
>>
>>
>> Capturing the info necessary to translate numbers into symbols is one
>> of the problems of host<->guest tracing so I'm curious how you handle
>> this :).
>
>
> Right, your consideration is true.
>
>
>> Apologies for my lack of ftrace knowledge but how useful is the raw
>> tracing data on the host?  How do you pretty-print it in
>> human-readable form?
>
>
> perf and trace-cmd can actually translate raw-formatted trace data to
> text-formatted trace data by using information of kernel or trace
> format under tracing/events directory in debugfs. In the same way, if
> the information of a guest is exported to a host, we can translate
> raw trace data of a guest to text trace data on a host. We will use
> 9pfs to export that.

Thanks, it's clear now :).

Stefan
