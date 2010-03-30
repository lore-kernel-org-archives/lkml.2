Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0C3RCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:02:55 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:55693 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab0C3RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RDNpHubwZJFGAPFvpuE5DFDbbjm7sriTsB1edFEovzo5mY9V8cZ2UqCsaZtK+uEycz
         WuJajYl8hcdAJTaky/txAm6+5lmCTRffcM5vGY8x1Xx9S6x/QLnTMHl9pMuNAAFvw/Sl
         mcS2CqoslGwxYKEhpf1kOISpeJuBwTwg5J/s8=
Message-ID: <4BB22EBB.1070507@pobox.com>
Date: Tue, 30 Mar 2010 13:02:51 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] libata: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org> <1269885165-18617-16-git-send-email-tj@kernel.org>
In-Reply-To: <1269885165-18617-16-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 01:52 PM, Tejun Heo wrote:
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Stephen Rothwell<sfr@canb.auug.org.au>
> Cc: Jeff Garzik<jgarzik@pobox.com>
> ---
>   drivers/ata/ahci_platform.c |    1 +
>   drivers/ata/libahci.c       |    1 +
>   2 files changed, 2 insertions(+), 0 deletions(-)

applied


