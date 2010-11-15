Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab0KOECH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 23:02:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60210 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab0KOECF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 23:02:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aUqy4baPOIF1r2bOPu76K2ou1GNgj0gCjmb0VbQBh+C/Goyz/1CM+tSaVNaC3HdkCh
         gJcB1IKEw9wrI48/OgVapwQqcBDyvXp8tIzrNaQXiy3Dm9eLh77UYKO0tTFwCeI1XmRT
         e3YEbEdfSEuMKrxtyoruxE2Moi3cpzAQkYgwU=
Message-ID: <4CE0B0B8.1010809@garzik.org>
Date: Sun, 14 Nov 2010 23:02:00 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: Re: [PATCH] sata-via: enable magic transmission fix for vt6420
References: <1289737911.24491.7.camel@twins>
In-Reply-To: <1289737911.24491.7.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 07:31 AM, Peter Zijlstra wrote:
> I was able to reproduce and test the transmission error on vt6420
> hardware with the 2G WD drives. Adding the controller ID to this fix
> seems to result in a properly working system.
>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>

Please CC linux-ide and myself on all libata patches, as MAINTAINERS and 
drivers/ata/sata_via.c both indicate.

