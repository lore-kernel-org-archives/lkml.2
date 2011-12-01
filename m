Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1LAGHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 01:07:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44955 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab1LAGHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 01:07:39 -0500
MIME-Version: 1.0
In-Reply-To: <20111201032113.GA6917@suse.de>
References: <20111130233733.GA11577@maxin> <CAGTjWtCy_syX18y23mUD7HZJe3fdjUDCY7YDMwKesFFjd4VwZQ@mail.gmail.com>
 <20111201032113.GA6917@suse.de>
From: Mike Waychison <mikew@google.com>
Date: Wed, 30 Nov 2011 22:07:16 -0800
Message-ID: <CAGTjWtC2Toqd8H1Z9pHky7nJguOyedUoypU5zrWvi8X+v4cD3Q@mail.gmail.com>
Subject: Re: [PATCH] firmware: google: fix gsmi.c build warning
To: Greg KH <gregkh@suse.de>
Cc: "Maxin B. John" <maxin.john@gmail.com>, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, dlaurie@google.com, adurbin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 7:21 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Nov 30, 2011 at 03:56:25PM -0800, Mike Waychison wrote:
>> On Wed, Nov 30, 2011 at 3:37 PM, Maxin B. John <maxin.john@gmail.com> wrote:
>> > Use min_t() macro instead of min() to fix a build warning:
>> >
>>
>> Looks good.  Greg, could you please pull this into your drivers tree?
>
> Yes I will if you ack it :)

Acked-By: Mike Waychison <mikew@google.com>

>
> greg k-h
