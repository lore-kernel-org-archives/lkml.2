Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1KBVOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:14:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59283 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1KBVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:14:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1111022209560.348@pobox.suse.cz>
References: <CALKntY3zkAHc92_6Sk2Mg06J6N1RCj38O7AQk0a5d6pCtivD-Q@mail.gmail.com>
	<alpine.LRH.2.00.1111022205100.17927@twin.jikos.cz>
	<CALKntY1S9HCQkqVBQSJLUO=L=DfwaSuN4m=akJBKuQ2dxBj4MQ@mail.gmail.com>
	<alpine.LNX.2.00.1111022209560.348@pobox.suse.cz>
Date: Wed, 2 Nov 2011 17:14:17 -0400
Message-ID: <CALKntY2yJm1Usi60dbZo-8OmfpfZp4AELFbw7QH5QsgvjFLdCQ@mail.gmail.com>
Subject: Re: Undefined Instruction
From: Xin Tong <xerox.time.tech@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There must be a default handler install for every application on linux
, right  ? Is there any signal that the operating system simply kills
the programs without sending a signal to the user level ?

Thanks

Xin

On Wed, Nov 2, 2011 at 5:10 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 2 Nov 2011, Xin Tong wrote:
>
>> If i change the kernel, i could have the application stary alive right ?
>
> No need for any kernel changes. You can set your own signal handler for
> SIGILL (but iirc that will make any further behavior of your application
> undefined as long as POSIX is involved).
>
> --
> Jiri Kosina
> SUSE Labs
>
