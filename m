Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2GAH11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 03:27:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34138 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2GAH10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 03:27:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAMPhdO99maVhhpzLC_v9ZBdt=2=KNAg4oEn+wbQYmhYTEtTGgw@mail.gmail.com>
References: <1339505386.30984.123.camel@x61.thuisdomein>
	<CAMPhdO99maVhhpzLC_v9ZBdt=2=KNAg4oEn+wbQYmhYTEtTGgw@mail.gmail.com>
Date: Sun, 1 Jul 2012 15:27:25 +0800
Message-ID: <CAN1soZxwF1sw-w6UQsCNo_FQ-Soq9b3J8XiF+WGYxezn8dix9Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: remove eseries.h
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 9:19 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Tue, Jun 12, 2012 at 8:49 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> Commit e478fe4cd50b86e95fadc415438b63fa94060b7d ("[ARM] pxa: merge all
>> eseries board code into eseries.c") removed all six files that included
>> eseries.h. Everything that this header provides is now either local to
>> eseries.c or entirely unused. It was apparently just an oversight to
>> keep this header. This header can safely be removed.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>
> That was long time ago. I'm basically good with the removal. Haojian, could
> you give a simple test maybe?
>
Applied

Regards
Haojian
