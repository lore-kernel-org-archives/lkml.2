Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0ESGMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:12:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44939 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0ESGMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tkF8B0TaFg2L4+U3yFC3vxRKf+HZ9132OzlYh+1Zz2kAFYTmmfVBge9t93N/YCg5gc
         d0XD3p1uxd6MWx7NV2f16oXFqZN8dwwZ7mL/Y5SvkHW0lPRK2fKH6+f8fD1ECeH9tlAd
         VMqfCNZsjnaKqNCpq3P1qot9+bU6JTYoVLMuY=
MIME-Version: 1.0
In-Reply-To: <1274248526.2667.2.camel@ubuntu.ubuntu-domain>
References: <1274248526.2667.2.camel@ubuntu.ubuntu-domain>
Date: Wed, 19 May 2010 09:12:46 +0300
X-Google-Sender-Auth: o3fvsfvbjlOOb4tghWRLYkrHptc
Message-ID: <AANLkTimb0ZdGxKtQnfFhIw2tqwVDJEWZ6yV58Fv5b74I@mail.gmail.com>
Subject: Re: [PATCH] Staging: winbond: Fix C99 Comment issues in 
	mac_structures.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: adam.latham@unisontorbay.org.uk
Cc: gregkh@suse.de, sankar.curiosity@gmail.com, ruslan@rpisarev.org.ua,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 8:55 AM, Adam Latham
<adam.latham@unisontorbay.org.uk> wrote:
> >From 75719374c007bfb664b866df3e7c1f30c93354d4 Mon Sep 17 00:00:00 2001
> From: Adam Latham <adam.latham@unisontorbay.org.uk>
> Date: Tue, 18 May 2010 20:00:00 +0100
> Subject: [PATCH] Staging: winbond: Fix C99 Comment issues in mac_structures.h
>
> This patch fixes the use of //C99 comments in the mac_structures.h found by
> the checkpatch.pl tool
>
> Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
