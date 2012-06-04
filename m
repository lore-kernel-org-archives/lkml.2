Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2FDLpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:45:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54920 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2FDLpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120519033154.GA12188@ioremap.net>
References: <1337330963-20485-1-git-send-email-devendra.aaru@gmail.com>
	<20120519033154.GA12188@ioremap.net>
Date: Mon, 4 Jun 2012 17:15:01 +0530
Message-ID: <CAHdPZaM0pc_2_5Qapk-TwVcXpvYq2F0CHZ_9Cii6Zo=TmT1FGQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/w1: cleanup w1_uevent
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, GregKH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mr Greg,

are you going to take this in?

Thanks,
Devendra.

On Sat, May 19, 2012 at 9:01 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Hi
>
> On Fri, May 18, 2012 at 02:19:23PM +0530, Devendra Naga (devendra.aaru@gmail.com) wrote:
>> There were some return statements around in the w1_uevent, used goto
>> to cleanup those return statements with the help of err variable,
>> and also removed a semi colon at the end of the w1_uevent's closing
>> brace.
>
> I personally do not see whether this is better than what was before
> So, Greg, it is up to you to decide :)
>
> If you pull it in, then feel free to add my acked-by.
> Thank you.
>
>        Evgeniy Polyakov
