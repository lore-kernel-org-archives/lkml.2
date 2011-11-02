Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1KBVIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:08:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61954 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1KBVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1111022205100.17927@twin.jikos.cz>
References: <CALKntY3zkAHc92_6Sk2Mg06J6N1RCj38O7AQk0a5d6pCtivD-Q@mail.gmail.com>
	<alpine.LRH.2.00.1111022205100.17927@twin.jikos.cz>
Date: Wed, 2 Nov 2011 17:08:28 -0400
Message-ID: <CALKntY1S9HCQkqVBQSJLUO=L=DfwaSuN4m=akJBKuQ2dxBj4MQ@mail.gmail.com>
Subject: Re: Undefined Instruction
From: Xin Tong <xerox.time.tech@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If i change the kernel, i could have the application stary alive right ?

Thanks

Xin


On Wed, Nov 2, 2011 at 5:07 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 2 Nov 2011, Xin Tong wrote:
>
>> If an application contains an undefined instruction to the processor (
>> x86 in particular ) how does the operating system handle it. does the
>> operating system just kill the process, or it will throw signals,
>> trying to recover from it ?
>
> CPU will trap and kernel will send SIGILL to the process.
>
> --
> Jiri Kosina
> SUSE Labs
>
>
