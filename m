Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0IFVHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 17:07:37 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39940 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab0IFVHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 17:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OjJcLLRp71+yE6NLM9E90ysoNGjS1G6UW1uYA9WB2A9wg0t3N5IPqEMl3X5fK6Vfv5
         0qxLl0BF+69NR9BFufwh4xZH1BSnBNSn0etkrkp7JnVszdnQbn2kvbbBtpDceuQYALyJ
         k1sOmR719vl40cMvCfjue8UqpTMsh0x//JIWg=
MIME-Version: 1.0
In-Reply-To: <1283772201-15453-1-git-send-email-nicolas.ferre@atmel.com>
References: <201009060548.18521.fg@emlix.com>
	<1283772201-15453-1-git-send-email-nicolas.ferre@atmel.com>
Date: Mon, 6 Sep 2010 23:07:30 +0200
Message-ID: <AANLkTiny_0n3YT6+-GbpRzMcxBOF7x1P6b0Ynv_s3fR=@mail.gmail.com>
Subject: Re: [PATCH] AT91: SAM9G45 - add a separate clock entry for every
 single TC block
From: "avictor.za@gmail.com" <avictor.za@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabian Godehardt <fg@emlix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Without this patch you will not be able to register the first block
> because of the second association call on at91_add_device_tc().
>
> Signed-off-by: Fabian Godehardt <fg@emlix.com>
> [nicolas.ferre@atmel.com: change tcb1_clk to fake child clock of tcb0_clk]
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Nicolas Ferre

Acked-By: Andrew Victor <linux@maxim.org.za>
