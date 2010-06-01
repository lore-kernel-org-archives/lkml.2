Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0FAUrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:47:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:43193 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0FAUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:47:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=bsOzIlfD78sIkby682BnyctHi8dhZSyNxeKdPCMGBtKkB/0s0LGl+2iGjlErua3i3
	1GBps7vlE8GQNwSCQKwwQ==
MIME-Version: 1.0
In-Reply-To: <20100601202058.GD4093@ghostprotocols.net>
References: <4c055fb7.df0ce30a.5f0d.ffffae52@mx.google.com>
	<20100601202058.GD4093@ghostprotocols.net>
Date: Tue, 1 Jun 2010 22:46:57 +0200
Message-ID: <AANLkTin5OVSGAWn3ibZKYq-hQZxOe_hSkEYcOJjD288-@mail.gmail.com>
Subject: Re: [PATCH] perf: add perfconfig option to specify buildid cache dir
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 10:20 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Tue, Jun 01, 2010 at 09:25:01PM +0200, Stephane Eranian escreveu:
>> This patch adds the ability to specify an alternate directory
>> to store the buildid cache (buildids, copy of binaries). By
>> default, it is hardcoded to $HOME/.debug. This directory
>> contains immutable data. The layout of the directory is such
>> that no conflicts in filenames are possible. A modification
>> in a file, yields a different buildid and thus a different
>> location in the subdir hierarchy.
>
> There are some minor nits about coding style and that tolower part that
> seems to be better suited for being in a separate patch with a separate
> explanation as to why it is needed (is it really?), but yeah, that is a
> worthy change and I'll test and merge it, thanks!
>
The tolower() is needed (at least I think) because pathname are case
sensitive, the rest isn't in this config file so far.

Thanks for your consideration.
