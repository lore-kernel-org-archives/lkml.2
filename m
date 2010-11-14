Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab0KNUcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:32:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab0KNUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:32:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GnTlsdtEkg0ANK+6rDFbdKkEWmsgwak+l5NUt97RKbulchVJR9WfnW18mFyyFRe7sl
         WMWfedRr3d8aHOZyAwiYRUUEbkHIRTSmigeILZxOTge9BfIVwRUOSD06h+zWIDrTCqMR
         weztQED9nuOOcB9zOSO3YBqpLRIBUibnXb4UY=
Subject: Re: [PATCH] net: bnx2x: fix error value sign
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Eilon Greenstein <eilong@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289766583.2743.144.camel@edumazet-laptop>
References: <1289765315-6028-1-git-send-email-segoon@openwall.com>
	 <1289766583.2743.144.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 21:32:08 +0100
Message-ID: <1289766728.2743.147.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 novembre 2010 à 21:29 +0100, Eric Dumazet a écrit :

> I remember sending same patch in the past... it was lost somehow...

Ah, it was another issue, patch was not lost ;)



