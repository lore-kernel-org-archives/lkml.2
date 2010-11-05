Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0KEXjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:39:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054Ab0KEXjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <4CD48E04.2050709@oracle.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
 <20101103161837.fad11d79.randy.dunlap@oracle.com> <AANLkTimnHFHJq13xpJ0ZgLmpd+cHmHH5sQ4HWtL_MrMT@mail.gmail.com>
 <4CD48E04.2050709@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Nov 2010 16:38:14 -0700
Message-ID: <AANLkTik80AuVEefHwccB81WPdT4UPfTSjQdG-3Yq17e7@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc1 (libipw remove_proc_entry warning)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pavel Roskin <proski@gnu.org>, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 4:06 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 11/05/10 15:24, Linus Torvalds wrote:
>>
>> Totally UNTESTED patch attached. It may or may not compile. And maybe
>> it doesn't catch all cases, but it should catch the obvious ones.
>
> That works for me.
>
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Goodie. Pavel, John - feel free to add my sign-off on that patch. Make
up a relevant commit message. Ok?

                     Linus
