Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0C1EqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:46:06 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:65040 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0C1EqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L6y4YsMPLfpc2RTFJ74V1JmpwZHAR8xoAMg7EnjMRfmj351nfSWkk8cMKSY9eyRazN
         0Zc514+XG+fWGtUK/zbKDQGt7yo435GxzvPbI9UMGxkK1uB0Wm8R9vZvl2LvchHYHFxk
         FYG/bzYsyDl3LEecikf+TWstsqkWyPtnWqMrA=
Message-ID: <4BAEDF05.9070006@garzik.org>
Date: Sun, 28 Mar 2010 00:45:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shane Huang <shane.huang@amd.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: linux-next: manual merge of the libata tree with Linus' tree
References: <20100322124422.4a10bc4a.sfr@canb.auug.org.au>
In-Reply-To: <20100322124422.4a10bc4a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 09:44 PM, Stephen Rothwell wrote:
> Hi Jeff,
>
> Today's linux-next merge of the libata tree got a conflict in
> drivers/ata/ahci.c between commit
> 5db5b0215af94a36d4bf10900ff9707b6d5c1610 ("ahci: pp->active_link is not
> reliable when FBS is enabled") from Linus' tree and commit
> efd7cb719e07433588ee5c6a99b1208b0aff6295 ("ahci: Move generic code into
> libahci") from the libata tree.
>
> I applied the changes to drivers/ata/ahci.c from the former commit to
> drivers/ata/libahci.c (where the latter commit moves it).

Should be fixed now...


