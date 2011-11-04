Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab1KDK2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:28:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35715 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab1KDK16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <4EB30C0B.8080200@xenotime.net>
References: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au> <4EB30C0B.8080200@xenotime.net>
From: Mark Einon <mark.einon@gmail.com>
Date: Fri, 4 Nov 2011 10:27:37 +0000
Message-ID: <CANK3SE0GpJxqz6X6LTqSapUZaWLMtjyAPda5iJbZYd79LMsFeg@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 3 (staging/et131x)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 November 2011 21:47, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 11/02/2011 11:20 PM, Stephen Rothwell wrote:
>> Hi all,
>
>
> When CONFIG_PM_SLEEP is not enabled:
>
> drivers/staging/et131x/et131x.c:5489:12: error: 'et131x_pci_setup' undeclared here (not in a function)

Hi Randy,

I'm having trouble reproducing this with the current linux-next tree.
Could you post the config that gives you this error please?

Cheers,

Mark
