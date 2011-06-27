Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1F0JZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:25:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64882 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab1F0JXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:23:04 -0400
Message-ID: <4E084BB0.10806@mvista.com>
Date: Mon, 27 Jun 2011 13:21:52 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, kernel-janitors@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Rupjyoti Sarmah <rsarmah@appliedmicro.com>,
        Prodyut Hazarika <phazarika@appliedmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: sata_dwc_460ex: fix error path
References: <1284317830-5022-1-git-send-email-segooon@gmail.com> <4D5C1326.2010101@ru.mvista.com> <4D628543.5090700@mvista.com>
In-Reply-To: <4D628543.5090700@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-02-2011 18:31, Sergei Shtylyov wrote:

>>> Free all allocated resources on error path.

>>> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
>>> ---
>>> I cannot compile this driver at all, so it is not tested.

>> I can at least compile-test the patch...

> No new errors/warnings are added by the patch.

    Vasiliy, could you repost this patch? I'm not sure why Jeff hasn't taken 
it, maybe he will now...

WBR, Sergei
