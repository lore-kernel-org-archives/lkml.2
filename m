Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2GaMyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:54:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54132 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab2GaMyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:54:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120729193948.GA26497@merkur.ravnborg.org>
References: <1343570792-10604-1-git-send-email-chenbdchenbd@gmail.com>
	<20120729193948.GA26497@merkur.ravnborg.org>
Date: Tue, 31 Jul 2012 20:54:51 +0800
Message-ID: <CAEAuANOHFYsDX-brey=83GvGWCwFJ9Lu_=8vsUu2a47bxaPN4g@mail.gmail.com>
Subject: Re: [PATCH] staging:net:fixed to fit tty_driver's kref field
From: Baodong Chen <chenbdchenbd@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 3:39 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Jul 29, 2012 at 10:06:32PM +0800, Baodong Chen wrote:
>> Fixed code to fix tty_driver's kref field
>> Coding style issues
>>
>> Signed-off-by: Baodong Chen <chenbdchenbd@gmail.com>
>
> Hi Baodong.
>
> As already pointed out by Jiri please split this
> up in several patches.
>
> [PATCH 1/x] staging:net:pc300: fix white space usage
> [PATCH 2/x] staging:net:pc300: add proper kref support
> [PATCH 3/x] staging:net:pc300: use pr_dev
> [PATCH 4/x] staging:net:pc300: drop use of CPC_TTY_LOCK/CPC_TTY_UNLOCK macros
> etc...
>
> The latter two is not impleted yet but proposals for further cleanups.
>
>         Sam
ok, i will follow that rule and resubmit it.
thanks!

>
>> ---
>>  drivers/staging/net/pc300_tty.c |  123 ++++++++++++++++++++------------------
>>  1 files changed, 65 insertions(+), 58 deletions(-)
>>
>> diff --git a/drivers/staging/net/pc300_tty.c b/drivers/staging/net/pc300_tty.c
>> index 4709f42..8a7277c 100644
>> --- a/drivers/staging/net/pc300_tty.c
>> +++ b/drivers/staging/net/pc300_tty.c
>
>>
>> -     cpc_tty = (st_cpc_tty_area *) tty->driver_data;
>> +     cpc_tty = (st_cpc_tty_area *) tty->driver_data;
>                                      ^drop space
>
