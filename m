Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1AKRBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:01:21 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47047 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab1AKRBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tnKvmn0mbLIVtdqvzHegjeemGmwtPK4cgZ3gMoyTWYBz3DV3ci/4bmsSnrXDdwxaHp
         yCslhqCMlzR7SI0vytFVjTeJRkdLpixMya+quDtSoS7oOTTs6uOPgg01D88OYMKCDMWR
         pkV26nxuX/ebH6fTLeKuIp9g/i+TT04zlF4SM=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com,
        jj@chaosbits.net, daniel.baluta@gmail.com, jochen@jochen.org,
        hagen@jauu.net, torvalds@linux-foundation.org, pavel@ucw.cz
In-Reply-To: <1294764515-15356-1-git-send-email-stefani@seibold.net>
References: <1294764515-15356-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 18:01:13 +0100
Message-ID: <1294765273.2927.65.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 11 janvier 2011 à 17:48 +0100, stefani@seibold.net a écrit :
> From: Stefani Seibold <stefani@seibold.net>
> 
...
> The implementation is clean and has absolut no side effects to the network
> subsystems so i ask for merge it into linux, mm-tree or linux-next.
> 
> The patch is against the current linux git tree
> 
> - Stefani
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  

Reading again UDPCP specs, I find it is IPv4/IPv6 agnostic

You copied IPv4 UDP code, so this only handles IPv4...



