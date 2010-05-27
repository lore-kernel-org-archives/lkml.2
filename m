Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab0E0Pwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:52:49 -0400
Received: from smtp-out.google.com ([74.125.121.35]:40001 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab0E0Pws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:52:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=T9WDKwiNgQt2FTK7/+eGEjbv7/2zNwsKYxn0LoZEkqS1cnh3U5DZymdTTGiBCnK82
	0oi2AjrksO+hPnNxSBMCA==
MIME-Version: 1.0
In-Reply-To: <20100527154510.GK9874@ghostprotocols.net>
References: <4bfe6b18.914ed80a.0573.4c6e@mx.google.com>
	<20100527145142.GJ9874@ghostprotocols.net>
	<20100527154510.GK9874@ghostprotocols.net>
Date: Thu, 27 May 2010 17:52:42 +0200
Message-ID: <AANLkTinrLDskqxBbrCa6XJ45yp-pdhwWkrj65a47Tb52@mail.gmail.com>
Subject: Re: [PATCH] perf: fix use_browser infinite loop bug in annotate
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 5:45 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Thu, May 27, 2010 at 11:51:42AM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, May 27, 2010 at 02:50:01PM +0200, Stephane Eranian escreveu:
>> > This patch fixes an infinite loop problem with perf annotate when
>> > the TUI is not used. When the perfconfig file is not found use_browser
>> > remains at -1, when found and tui is disabled use_browser = 0. Thus the
>> > correct test for TUI is use_browser > 0.
>> >
>> > Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> Thanks, I'm applying this one and doing an audit of other uses, I know
>> of one more case reported by Frédéric that was fixed in a similar way.
>
>        Oops, I already have this fixed on changeset
>
> 62e3436b5f3461662929eae102beefbd12127cb1
>
>        That is at:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
>
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commit;h=62e3436b5f3461662929eae102beefbd12127cb1
>
>        I pushed this to Ingo yesterday, should be in tip/perf/core soon,
> thanks anyway!
>
Ok, if it's fixed then this is fine. The other problem I reported is
more important.
Thanks for checking.
