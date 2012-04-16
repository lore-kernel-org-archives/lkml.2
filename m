Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2DPWJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:09:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43507 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab2DPWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:09:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAE_yGnDYkoJYVus-iPinSnqTj1CDfaf-oScPjZ2ibDaeeWF0oQ@mail.gmail.com>
References: <CAE_yGnAWsWQHCSCLA-LCuugOGTf5L4v2NcQatar4Vv421TNQcw@mail.gmail.com>
	<CAE_yGnDYkoJYVus-iPinSnqTj1CDfaf-oScPjZ2ibDaeeWF0oQ@mail.gmail.com>
Date: Mon, 16 Apr 2012 15:09:51 -0700
X-Google-Sender-Auth: UKydSgZrIMe1R4W8gktRH2bA--Q
Message-ID: <CAE9FiQW5LwRdM2NRUQZjBkyg023gwXa6r10Ym2bo0L1vk74yBg@mail.gmail.com>
Subject: Re: can't boot my laptop with kernel-3.3.*
From: Yinghai Lu <yinghai@kernel.org>
To: Scant Light <scantlight@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 7:35 AM, Scant Light <scantlight@gmail.com> wrote:
> I don't know if this is the right place,
> however I write you to say that I have a problem to boot my laptop
> using a kernel with version greater that 3.2.*
> the error message can be found on photo situated at
> http://www.pasteall.org/pic/30277
>
> what kind of other information you need for this?
>

can you append  with "debug ignore_loglevel apic=debug"

Yinghai
