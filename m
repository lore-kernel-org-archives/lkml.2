Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0EQTgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:36:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5141 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab0EQTgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:36:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=EcRCRCr6qApDJKIhnPfvGcrnQ9JIxiJFiRJaioQbXVnysNkvFEuXAqzuRM4Kwnd3D
	cWeWBqS47aQ7Nh2W97EMg==
MIME-Version: 1.0
In-Reply-To: <4BF197F3.1030803@redhat.com>
References: <4bf194a4.5cebd80a.2e1f.ffffcc32@mx.google.com>
	 <4BF197F3.1030803@redhat.com>
Date: Mon, 17 May 2010 21:36:44 +0200
Message-ID: <AANLkTillPMTPrmCgnnr_p8t4Vh4sFmyjISPNtAMn4O_C@mail.gmail.com>
Subject: Re: [PATCH] perf: fix Makefile check for libdward
From: Stephane Eranian <eranian@google.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 9:24 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> Hi Stephane,
>
> Stephane Eranian wrote:
>> On Ubuntu 9.10, the elfutils/libdw package is 0.141, yet it is
>> not sufficient to compile util/probe-finder.c as it uses a type,
>> namely Dwarf_CFI, which is introduced sometime after version 0.141.
>>
>> This patch updates the libdwarf test in the Makefile to check
>> for the definition of Dwarf_CFI. If is is not there, the test
>> fails and dwarf support is disabled.
>>
>> It is not clear to me which version introduces Dwarf_CFI,
>> thus I adjusted the version message to 0.142, could be more
>> recent.
>
> Yeah, I see. I had sent a fix patch which just ignores Dwarf_CFI
> related code if the libdw version is younger than supporting it.
> Could you try the patch here?
>
Does compile now on Ubuntu 9.10 (Karmic).
Thanks.

> https://patchwork.kernel.org/patch/98216/
>
> Thank you,
>
> --
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com
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
