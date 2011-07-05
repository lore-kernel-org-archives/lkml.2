Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1GEM2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:28:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39530 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab1GEM2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <201107051402.50533.richard@nod.at>
References: <1309821347.4527.6.camel@vitaliy-Vostro-1400>
	<201107051142.39733.richard@nod.at>
	<CAGTPOqebcT_Dd5nPSNEkrDvnCgYhqcU=ayjEA8L7Zh0Wr_pj5w@mail.gmail.com>
	<201107051402.50533.richard@nod.at>
Date: Tue, 5 Jul 2011 15:28:03 +0300
Message-ID: <CAGTPOqfXfSwAvTKrfby_Q4A0xTUq5teD7br0jagoBWwYK+JhRw@mail.gmail.com>
Subject: Re: [PATCH 2/4] uml: helper.c warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 3:02 PM, Richard Weinberger <richard@nod.at> wrote:
> Am Dienstag 05 Juli 2011, 13:45:06 schrieb Vitaliy Ivanov:
>> It's always better not to think whether it's possible but simply kill
>> all the chances for this to happen.
>> In this case that's pretty trivial thing and also it solves issue with
>> warning.
>
> Defensive programming is not a solution for everything.
> CPU time and memory are not for free, especially in kernel land.
>
> Anyway, when this patch removes a real warning, it's fine for me.
> Applied.

Thanks Richard.
