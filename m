Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab2CUP5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:57:10 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:60888 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab2CUP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:57:08 -0400
Message-ID: <4F69FA4A.3010909@t-online.de>
Date: Wed, 21 Mar 2012 16:56:58 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, arekm@maven.pl,
        Jared <nitro@legroom.net>, dilieto@lineone.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: override for PCI legacy power management
References: <4F69BE2E.7070903@t-online.de> <20120321083205.360a7a3b@nehalam.linuxnetplumber.net>
In-Reply-To: <20120321083205.360a7a3b@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: GcbA-mZHQhHE-w2G8nCoWb6Fdb6V77+uYyY9kRFBmtdGVw0m-JU-kj0OZZdVClaZEe
X-TOI-MSGID: f5743370-b6da-469e-8bed-78e7d98cc16c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot!

> Some BIOS's don't setup power management correctly (what else is
> new) and don't allow use of PCI Express power control. Add a special
> exception module parameter to allow working around this issue.
> Based on slightly different patch by Knut Petersen.
>
> Reported-by: Arkadiusz Miskiewicz<arekm@maven.pl>
> Signed-off-by: Stephen Hemminger<shemminger@vyatta.com>
>

