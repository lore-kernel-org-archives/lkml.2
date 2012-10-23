Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2JWWCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:02:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61084 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2JWWCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121023215032.GA12908@aepfle.de>
References: <20121023194233.GA23588@aepfle.de>
	<CAE9FiQV-FF9F7P6s3kMBjuyR3jWZ_VFERt83UVZmc7P37gLeTA@mail.gmail.com>
	<20121023215032.GA12908@aepfle.de>
Date: Tue, 23 Oct 2012 15:02:05 -0700
X-Google-Sender-Auth: raW7jucM9-1lo03zITz7_vJht04
Message-ID: <CAE9FiQVyBQVVdypy1SqdrQuSHCe2y1axS8ShvfOxBpbEhqA=kA@mail.gmail.com>
Subject: Re: when to switch from early_ioremap to ioremap
From: Yinghai Lu <yinghai@kernel.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 2:50 PM, Olaf Hering <olaf@aepfle.de> wrote:
> On Tue, Oct 23, Yinghai Lu wrote:
>
>> Also early_ioremap has slot limitation: 4. and you should not hold one
>> slot too long, otherwise other users could
>> have problem to reach the limit.
>
> Thanks. After which init call is ioremap available anymway?

after mm_init
