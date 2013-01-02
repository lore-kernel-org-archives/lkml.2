Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3ABCIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 21:08:54 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:41311 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab3ABCIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 21:08:52 -0500
MIME-Version: 1.0
In-Reply-To: <50E30736.9050207@gmx.de>
References: <50E2C87A.3090000@gmx.de>
	<50E30736.9050207@gmx.de>
Date: Wed, 2 Jan 2013 10:08:52 +0800
Message-ID: <CAJd=RBCq8zb06aehCZWoX2wO0=1F7GbnkRRjC+WVAc59Y6j8Qg@mail.gmail.com>
Subject: Re: kernel bug at mm/huge_memory.c:1789 for v3.8-rc1-91-g4a490b7
From: Hillf Danton <dhillf@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 1, 2013 at 11:56 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> I found this in the syslog (sry for the big unnecessary JPEG in the previous message,
> I wasn't aware, that the syslogd was still working):
>
> 2013-01-01T12:15:28.000+01:00 n22 ntpd[3095]: Listen normally on 5 ppp0 80.171.221.184 UDP 123
> 2013-01-01T12:15:28.000+01:00 n22 ntpd[3095]: peers refreshed
> 2013-01-01T12:18:32.394+01:00 n22 kernel: mapcount 0 page_mapcount 1
> 2013-01-01T12:18:32.394+01:00 n22 kernel: ------------[ cut here ]------------
> 2013-01-01T12:18:32.394+01:00 n22 kernel: kernel BUG at mm/huge_memory.c:1798!
>
Hey Toralf

Thanks for reporting the oops.
Other reported cases are  piled up at https://lkml.org/lkml/2012/12/24/173

Hillf
