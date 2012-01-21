Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2AUBUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 20:20:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60971 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2AUBUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 20:20:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120120.134652.1449418393129426502.davem@davemloft.net>
References: <1327072786-3134-1-git-send-email-standby24x7@gmail.com>
	<20120120.134652.1449418393129426502.davem@davemloft.net>
Date: Sat, 21 Jan 2012 10:20:05 +0900
Message-ID: <CALLJCT2bb44eaXbf8FFZYzL+MNaXA9TnSTNsdx9uWUL+L-OWRg@mail.gmail.com>
Subject: Re: [PATCH] [trivial] sctp : Fix typo in net/sctp/socket.c
From: Masanari Iida <standby24x7@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 3:46 AM, David Miller <davem@davemloft.net> wrote:
> From: Masanari Iida <standby24x7@gmail.com>
> Date: Sat, 21 Jan 2012 00:19:46 +0900
>
>> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
>>
>> Correct a typo "sctp_setsocktopt_bindx" to "sctp_setsockopt_bindx"
>> in net/sctp/socket.c
>
> There is no such list named "linux-netdev" it's just plain "netdev"
>
> Please fully resubmit this patch with the list name corrected, thank
> you.

Thanks for the correction.
I just re-submit the patch to netdev.

Masanari
