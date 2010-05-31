Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab0EaHbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:31:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54319
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab0EaHbv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:31:51 -0400
Date: Mon, 31 May 2010 00:32:00 -0700 (PDT)
Message-Id: <20100531.003200.102574775.davem@davemloft.net>
To: sjurbren@gmail.com
Cc: error27@gmail.com, sjur.brandeland@stericsson.com, eric.dumazet@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] caif: remove unneeded null check in caif_connect()
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikM6_-YgLcBtcxN_TA1ISHkRk6fCEJVOS7pRZel@mail.gmail.com>
References: <20100522204342.GV22515@bicker>
	<AANLkTikM6_-YgLcBtcxN_TA1ISHkRk6fCEJVOS7pRZel@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjurbren@gmail.com>
Date: Mon, 24 May 2010 21:56:01 +0200

> Dan Carpenter <error27@gmail.com> wrote:
>> We already dereferenced uaddr towards the start of the function when we
>> checked that "uaddr->sa_family != AF_CAIF".  Both the check here and the
>> earlier check were added in bece7b2398d0: "caif: Rewritten socket
>> implementation".  Before that patch, we assumed that we recieved a valid
>> pointer for uaddr, and based on that, I have removed this check.
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Thanks Looks good,
> Acked-by: Sjur Braendeland <sjur.brandeland@stericsson.com>

Applied.
