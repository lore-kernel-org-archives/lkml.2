Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab2DJVPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 17:15:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65109 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab2DJVPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 17:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120410204249.GA26627@electric-eye.fr.zoreil.com>
References: <CACPM=kWa=UWuCMaYAtVMGJ7pzCy-PfyNRWBSuJnTZGtssU0W6g@mail.gmail.com>
	<20120410204249.GA26627@electric-eye.fr.zoreil.com>
Date: Tue, 10 Apr 2012 23:15:18 +0200
X-Google-Sender-Auth: UAgqm0D4w-pBtiL1qhAvep7s8P8
Message-ID: <CACPM=kWsU8QZOHqwEThTQCuSSvaTDoxO1d17EyoW=+kx8QG3vw@mail.gmail.com>
Subject: Re: via-rhine: Problem with lost link after a while
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10. apr. 2012 22.42 skrev Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
> [...]
>> Got any ideas?
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;h=3f8c91a7398b9266fbe7abcbe4bd5dffef907643
>
> Courtesy of Andreas Mohr.

Great, I'll try a 3.4-rc2 kernel, and see how it runs.

The thread I was talking about earlier is here:
http://lists.soekris.com/pipermail/soekris-tech/2012-April/018318.html
Is there any of the changes he has there, that makes sense in the new
driver you wrote?

Thanks :)

/Bjarke

> --
> Ueimor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
