Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0LGOmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:42:52 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:53689 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0LGOmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=teP+BmcvFwUm28J2A91QdYYk4zoL55AgLvbap3/FkK/DFThLgTfqpwYovduKGZ89QO
         bDim9FegA/CeKEeLh9Il8YtCNK+odzXVyZQUIXVCwYir7nOQRb0HJboqeceIfRaA2AB9
         Ur0XmNb3jaR1+HLnon2pOJCNh3JZa3SZgYnc0=
Subject: Re: [PATCH] mach-at91: Support for gms board added.
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@maxim.org.za,
        linux@arm.linux.org.uk, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        costa.antonior@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <4CFD4395.6050006@bluewatersys.com>
References: <1291663938-8325-1-git-send-email-plyatov@gmail.com>
	 <4CFD4395.6050006@bluewatersys.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 17:42:45 +0300
Message-ID: <1291732965.1967.17.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ryan,

Thank you for time spent on the patch review.

I will send a new patch with
"[PATCH v2] mach-at91: Support for gms board added" subject.

This patch must be used instead of
"[PATCH] mach-at91: Support for gms board added".

Sorry if I do this incorrectly, but I was unable to find any good
information how to handle patch versioning.

It is unclear which way is required for versioning:
1) send only a next commit as "v2"?
2) send a completely new patch as "v2" which will replace original
patch?

Best regards!
--
Igor Plyatov

