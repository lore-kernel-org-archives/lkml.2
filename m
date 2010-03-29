Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0C2Ufq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:35:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52637 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0C2Ufp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=G56wV5VMxwWACkPtf5Rxmfe8vEZ9SG+tvX5fF9ELwfDd/Y/Nq2v1UxNgvY14mwDSm9
         HMghRnKY9RxMd9lDz1Aue0FuJj9TVI0F3mBnBYDHtDN0S02RAyX0hX68Ru7txRKW2YlC
         I/HDGaKzahDQm77FeHxw/HKbKRWkQ5QlTvDBQ=
MIME-Version: 1.0
In-Reply-To: <1269537767-7553-2-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
	 <1269537767-7553-2-git-send-email-andrea.gelmini@gelma.net>
Date: Mon, 29 Mar 2010 22:35:43 +0200
Message-ID: <cd73a99e1003291335v5e9456a1ief4a50201f6fbb2e@mail.gmail.com>
Subject: Re: [PATCH 01/16] ARM mach-at91: duplicated include
From: Andrew Victor <avictor.za@gmail.com>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Andrew Victor <linux@maxim.org.za>, Dmitry Torokhov <dtor@mail.ru>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> arch/arm/mach-at91/board-sam9m10g45ek.c: mach/hardware.h is included more than once
>
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

Acked-by: Andrew Victor <linux@maxim.org.za>

Please submit the patch to Russell King's patch tracking system.
