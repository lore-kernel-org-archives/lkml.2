Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1FHRa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:30:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56674 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1FHRaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bcIu3shrcPSBFZKVsPX0tABZ/KwZw+h6w7Njkz5PWNyC8oEoNtZqnGrt6CsxvwnGLq
         DrenfkkOSx3/Et0NPUkt0D7ky76FNAx3bP+5Ep+OHe2b//3xbyvng+8NEflhhY5aIeyv
         lRck8/nfebGBK3Tt+0ShKPwoTgotnuKNCRn+M=
MIME-Version: 1.0
In-Reply-To: <1307552775-3185-1-git-send-email-konrad.wilk@oracle.com>
References: <1307552775-3185-1-git-send-email-konrad.wilk@oracle.com>
Date: Wed, 8 Jun 2011 19:30:22 +0200
Message-ID: <BANLkTikrO=skNyEcRsA7FKE+TGVwz7pXzQ@mail.gmail.com>
Subject: Re: [PATCH] bugfix and cleanup patches in the TTM code for 3.1.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@redhat.com, thomas@shipmail.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

2011/6/8 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> The bug-fix "ttm: Do not increment the amount of pages in a pool by the current amount"
> I never observed, but found while looking at the code. The cleanup patch:
> "ttm: Fix spelling mistakes and remove unused #ifdef", I had posted earlier and Randy
> Dunlap graciously added some extra cleanups - which I have rolled in.

This is safe to put comments to the patch in the following place:


Signed-off-by: (...)
---
RIGHT HERE
---
 drivers/(...)


When applying such a patch comments will not be visible in git log.
You may find this easier method of commenting your patches.

-- 
Rafał
