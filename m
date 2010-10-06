Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0JFDnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:43:12 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35362 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab0JFDnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DBrE7OEaFQtBv9sKdqk9H/0YUZmM3z38N3wBiyNPmG2O1dzPUm02PqKXzISYG2IBHU
         MzxcX69MF+FRY+iX6D4UctIOW+A1JAbiCMJENx/uLOdf84mvSI9HHb9zQYPZRewyLCy6
         kQMwDs9f9h1jPbXKBrGTBit5sWtsYEcJwTYkc=
MIME-Version: 1.0
In-Reply-To: <20101005171911.GA6075@core2.telecom.by>
References: <AANLkTikcRppGD592yth-xaea961OczDhXX1Hj+qQ6fJH@mail.gmail.com>
	<20101005171911.GA6075@core2.telecom.by>
Date: Wed, 6 Oct 2010 11:43:09 +0800
Message-ID: <AANLkTikP-7U=KC3RsZoFjFW2WHFst20C+8drMDnbdGf3@mail.gmail.com>
Subject: Re: [PATCH] pid: remove unused include
From: jovi zhang <bookjovi@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: andre.goddard@gmail.com, hedi@sgi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 1:19 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Tue, Oct 05, 2010 at 07:20:26PM +0800, jovi zhang wrote:
>> remove unused include of pid.c
>
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -27,15 +27,12 @@
>>  */
>>
>> #include <linux/mm.h>
>> -#include <linux/module.h>
>
> This one is needed for EXPORT_SYMBOL_GPL.
>
>> -#include <linux/slab.h>
>
>
> This one is for kzalloc()
>
>> #include <linux/init.h>
>> #include <linux/rculist.h>
>> #include <linux/bootmem.h>
>> #include <linux/hash.h>
>> #include <linux/pid_namespace.h>
>> #include <linux/init_task.h>
>> -#include <linux/syscalls.h>
>
> This one can go, sys_wait4() usage was removed.
> Have you checked compilation?
>

Sorry, It's my fault, I just compile kernel/pid.o.
I'm kicking myself for did this.
