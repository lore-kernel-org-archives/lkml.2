Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0KZPlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:41:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61651 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0KZPlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:41:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jj3ucLIdGutS9JWpZmf2XPtUoeSSyT3oOBvqRqaQNKpSJ1XhV6ykjEPgwJ+aXmLyQe
         agOwTEbO2NlBbkMylt5yih6Ut2lczjR4KTS8Dp1aFEvRichP1CfIpGB2UJjoqi2ZMae7
         nYTSs5y3TA4kEh8eCzjoKh2FhdMzWq5IZri3M=
Subject: Re: [PATCH 06/17][trivial] mtd: Remove unnecessary casts of void
 ptr returning alloc function return values
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Kirk Lee <kirk@hpc.ee.ntu.edu.tw>
In-Reply-To: <alpine.LNX.2.00.1011082327290.23697@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011082327290.23697@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 17:40:28 +0200
Message-ID: <1290786028.2552.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 00:09 +0100, Jesper Juhl wrote:
> Hi,
> 
> The [vk][cmz]alloc(_node) family of functions return void pointers which
> it's completely unnecessary/pointless to cast to other pointer types since
> that happens implicitly.
> 
> This patch removes such casts from drivers/mtd/

Pushed to l2-mtd-2.6.git, thanks.


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

