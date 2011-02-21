Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1BUPct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:32:49 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63318 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1BUPcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:32:47 -0500
Message-ID: <4D628543.5090700@mvista.com>
Date: Mon, 21 Feb 2011 18:31:15 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
CC: kernel-janitors@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Rupjyoti Sarmah <rsarmah@appliedmicro.com>,
        Prodyut Hazarika <phazarika@appliedmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: sata_dwc_460ex: fix error path
References: <1284317830-5022-1-git-send-email-segooon@gmail.com> <4D5C1326.2010101@ru.mvista.com>
In-Reply-To: <4D5C1326.2010101@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I wrote:

>> Free all allocated resources on error path.

>> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
>> ---
>>  I cannot compile this driver at all, so it is not tested.

>    I can at least compile-test the patch...

    No new errors/warnings are added by the patch.

WBR, Sergei
