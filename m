Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2FDVlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:41:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52209 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771Ab2FDVlR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <4FCD28E4.3090409@gmx.de>
References: <4FCD28E4.3090409@gmx.de>
Date: Mon, 4 Jun 2012 23:41:16 +0200
Message-ID: <CAFLxGvxrhq9CreNzQAt2tyC84NUQgVtPMcqcSiNE9x-kc8YQpA@mail.gmail.com>
Subject: Re: chroot under kernel 3.4.x gives core dumps
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 11:30 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> In the rare cases, where the chroot doesn't crash, all subsequent
> commands cores instead.

Then it should be easily bisectable. :)
Can you please try?

-- 
Thanks,
//richard
