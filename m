Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2G3Olx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:41:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32853 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2G3Olu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:41:50 -0400
MIME-Version: 1.0
In-Reply-To: <1343658373.15432.18.camel@zakaz.uk.xensource.com>
References: <Pine.LNX.4.44L0.1206301023540.29029-100000@netrider.rowland.org>
	<5011F15A.3060007@kernel.org>
	<1343658373.15432.18.camel@zakaz.uk.xensource.com>
Date: Mon, 30 Jul 2012 16:41:48 +0200
Message-ID: <CAFLxGvz=cYJQhCi99trBN8=hGA9XmY8Z7weNmnASYTqAbr0PEw@mail.gmail.com>
Subject: Re: [PATCH] ACPI: replace strlen("string") with sizeof("string") -1
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 4:26 PM, Ian Campbell <ijc@hellion.org.uk> wrote:
> I thought gcc optimised strlen("string literal") into a compile time
> constant too. It does in a little userspace test I just wrote, but I
> didn't look at its behaviour with the kernel's strlen.

It depends whether you use the built-in strlen() or not.
AFAIK the kernel does not use the built-in variant.

-- 
Thanks,
//richard
