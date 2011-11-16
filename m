Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab1KPBhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:37:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40761 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab1KPBhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:37:48 -0500
MIME-Version: 1.0
In-Reply-To: <21257.1321403368@turing-police.cc.vt.edu>
References: <1321318357-17723-1-git-send-email-grundler@chromium.org>
	<21257.1321403368@turing-police.cc.vt.edu>
Date: Tue, 15 Nov 2011 17:37:47 -0800
X-Google-Sender-Auth: ylwxPLgvwhxYXQA-9kf_BXYSWr4
Message-ID: <CANEJEGtnUS5B1ggdoPn8gcCbFm==dfgHCgXVgcgpuooFUAowJA@mail.gmail.com>
Subject: Re: [PATCH 5/5] net-next:asix: v2 update VERSION only
From: Grant Grundler <grundler@chromium.org>
To: Valdis.Kletnieks@vt.edu
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 4:29 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 14 Nov 2011 16:52:37 PST, Grant Grundler said:
>
>> -#define DRIVER_VERSION "26-Sep-2011"
>> +#define DRIVER_VERSION "08-Nov-2011"
>
> Aren't these sort of things more than a tad silly for an in-kernel driver?

Definitely not. Supporting linux device drivers essentially requires
some mechanism like this. We could use anything (SHA1, Mayan Calendar,
etc). This driver happens to use a ISO-like date code.

Upstream drivers are routinely back ported to distro releases. Version
is the primary means for a vendor (like ASIX) to determine what was
back ported. Distro maintainers and 1st tier support organizations
also need to track versions and "ethtool -i" is the canonical way to
look this up on a running system.

grant
