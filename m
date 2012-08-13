Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab2HMNgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:36:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47701 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2HMNgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAP9ODKrSSEs+8t+TsMAwK3ncuTma9HJH=UndDYJ-zmyEgCXU4Q@mail.gmail.com>
References: <CAP9ODKrSSEs+8t+TsMAwK3ncuTma9HJH=UndDYJ-zmyEgCXU4Q@mail.gmail.com>
Date: Mon, 13 Aug 2012 10:36:51 -0300
X-Google-Sender-Auth: 3zNPWpHwTV_eK_kynn-l-7PZByQ
Message-ID: <CAP9ODKrGHaDoDKvdvdyej0TN59Qu8LUfNujV8RA5T1bHC2i5ZA@mail.gmail.com>
Subject: Re: Boot freeze after/during PCI initialization
From: Otavio Salvador <otavio@ossystems.com.br>
To: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:00 PM, Otavio Salvador <otavio@ossystems.com.br> wrote:
> Hello,
>
> One of machines we have freeze during initialization from time to time:
>
> freeze at: http://download.ossystems.com.br/~otavio/geode-freeze.jpg
> works at: http://download.ossystems.com.br/~otavio/geode-working-dmesg.txt
>
> This happens with 3.4 and 3.5 kernel and seems to not happen with 3.0.
>
> Any clue what might be causing it?

This seems to be the bug: https://bugzilla.kernel.org/show_bug.cgi?id=13941

It seems no progress has been done in properly identify the cause of
it (or the progress is not reported on the bug itself).

-- 
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br
