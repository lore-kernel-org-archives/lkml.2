Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1BHO7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:59:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43898 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab1BHO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=NDyYcG039feBY2QHjNmbV9ffJT1R40yTOzJU0/2ZE9h7SKAUdoqU1KGcca+J4Xtlke
         nkWGU0t86Sd1oWwvB9sTOazW2lhudgWQ9N7GPfHsCukToipiQvFD95i1obWxas9OcJL4
         2XGDPZfH1A4NMV8A3JDK3AYgDY1qbBPMPEZUA=
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-Id: <4E2FEB1E-9584-446C-94D9-1884E4414ABC@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20110208140355.GA2448@tuxdriver.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: WARNING: at kernel/lockdep.c:3151 check_flags+0x63/0x179()
Date: Tue, 8 Feb 2011 06:59:15 -0800
References: <4D50BF6D.5050408@gmail.com> <20110208140355.GA2448@tuxdriver.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8, 2011, at 6:03 AM, John W. Linville wrote:

> On Mon, Feb 07, 2011 at 07:58:37PM -0800, Justin P. Mattock wrote:
>> not sure if this is o.k. or not due to the message giving me a few
>> messages(full dmesg below)
>
> No idea, but it probably isn't good...the better question is what
> made you send this to linux-wireless?  Nothing in the stacktraces
> seems to point at wireless stuff...
>
> John
> --  
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.

shoot.. apologize for that, typed the wrong address for this. I'll  
resend the original to lkml

Justin P. Mattock
