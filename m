Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1KGWiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:38:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35324 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1KGWiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:38:17 -0500
MIME-Version: 1.0
In-Reply-To: <4EB8586B.5060804@jp.fujitsu.com>
References: <1320614101.3226.5.camel@offbook> <20111107112952.GB25130@tango.0pointer.de>
 <1320675607.2330.0.camel@offworld> <20111107135823.3a7cdc53@lxorguk.ukuu.org.uk>
 <20111107143010.GA3630@tango.0pointer.de> <4EB8586B.5060804@jp.fujitsu.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 7 Nov 2011 23:37:56 +0100
Message-ID: <CAPXgP118CzaTuV-kABfEC-D-+K75zdKVwbaYba+FuN7umJO4kA@mail.gmail.com>
Subject: Re: [RFC PATCH] tmpfs: support user quotas
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: mzxreary@0pointer.de, alan@lxorguk.ukuu.org.uk, dave@gnu.org,
        hch@infradead.org, hughd@google.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 23:15, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> (11/7/2011 6:30 AM), Lennart Poettering wrote:

> If you want per-user limitation, RLIMIT is bad idea. RLIMIT is only inherited
> by fork. So, The api semantics clearly mismatch your usecase.

Like RLIMIT_NPROC?

> Instead, I suggest to implement new sysfs knob.

Where would users show up in sysfs?

Kay
