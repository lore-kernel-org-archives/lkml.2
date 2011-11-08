Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1KHAdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:33:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49840 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1KHAds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:33:48 -0500
Message-ID: <4EB878F3.1040508@jp.fujitsu.com>
Date: Mon, 07 Nov 2011 19:33:55 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: kay.sievers@vrfy.org
CC: mzxreary@0pointer.de, alan@lxorguk.ukuu.org.uk, dave@gnu.org,
        hch@infradead.org, hughd@google.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] tmpfs: support user quotas
References: <1320614101.3226.5.camel@offbook> <20111107112952.GB25130@tango.0pointer.de> <1320675607.2330.0.camel@offworld> <20111107135823.3a7cdc53@lxorguk.ukuu.org.uk> <20111107143010.GA3630@tango.0pointer.de> <4EB8586B.5060804@jp.fujitsu.com> <CAPXgP118CzaTuV-kABfEC-D-+K75zdKVwbaYba+FuN7umJO4kA@mail.gmail.com>
In-Reply-To: <CAPXgP118CzaTuV-kABfEC-D-+K75zdKVwbaYba+FuN7umJO4kA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/7/2011 5:37 PM), Kay Sievers wrote:
> On Mon, Nov 7, 2011 at 23:15, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> (11/7/2011 6:30 AM), Lennart Poettering wrote:
> 
>> If you want per-user limitation, RLIMIT is bad idea. RLIMIT is only inherited
>> by fork. So, The api semantics clearly mismatch your usecase.
> 
> Like RLIMIT_NPROC?

I suggest to don't follow useless interfaces.

