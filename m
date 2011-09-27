Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1I0XUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:20:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56768 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1I0XUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:20:01 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwKyd5fuyxu2tGDbQ8gKiEj=z7uYdBRg9O46WN0sTeNTQ@mail.gmail.com>
References: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
	<CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
	<CA+55aFwKyd5fuyxu2tGDbQ8gKiEj=z7uYdBRg9O46WN0sTeNTQ@mail.gmail.com>
Date: Tue, 27 Sep 2011 19:20:00 -0400
Message-ID: <CACqU3MU8jkysNxFasdfy9ksqSo2ojiZ5LUwfcfX13MMRgVx2Xw@mail.gmail.com>
Subject: Re: Linux 3.1-rc7
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 27, 2011 at 7:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Sep 27, 2011 at 4:13 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>
>> this -rc fails to build on my config (attached):
>>
>> arch/x86/kernel/i387.c: In function 'restore_i387_xsave':
>> arch/x86/kernel/i387.c:726:1: warning: "/*" within comment
>
> Hmm. That seems completely bogus.
>
> Are you sure you have a clean kernel tree? Because I suspect that file
> is corrupted on your machine.
>
yes it was.

 - Arnaud
