Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0HZEwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:52:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab0HZEwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Dm+2m9ZzeKKDrENWvRpX7UsEDgkSt22yOaGC1i6xqZkwz+0a/z7hQ9hkWtlxYrNOQR
         5H0hzbfm6qsO3gJ0D7jnd5zyFvNRFvuVSwQh+Zwsx71YESruq89j778/xpkGmt6lQ4yp
         5vc/+EZzDB9DL2NuLDw4OZ+btRhS/MrcZef2A=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: Re: [PATCH v3 0/2] added initial support for TPO TD043MTEA1 LCD display on Aspenite
Date: Thu, 26 Aug 2010 06:51:57 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, haojian.zhuang@marvell.com,
        eric.y.miao@gmail.com, linux-kernel@vger.kernel.org
References: <1282794715-28640-1-git-send-email-mark.brown314@gmail.com>
In-Reply-To: <1282794715-28640-1-git-send-email-mark.brown314@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008260651.57454.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 26. srpna 2010 05:51:53 Mark F. Brown napsal(a):
> Mark F. Brown (2):
>   pxa168: added framebuffer support code.
>   pxa168: added initial support for TPO TD043MTEA1 LCD display on
>     Aspenite
> 
>  arch/arm/mach-mmp/aspenite.c            |   60
> +++++++++++++++++++++++++++++++ arch/arm/mach-mmp/include/mach/pxa168.h | 
>   8 ++++
>  arch/arm/mach-mmp/pxa168.c              |    3 ++
>  3 files changed, 71 insertions(+), 0 deletions(-)

It looks good to me, but the hardware specific goo is up to Haojian/Eric to 
check.

Cheers
