Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1KGIII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:08:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48539 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1KGIIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <1320585411.18391.4.camel@phoenix>
References: <1320585256.18391.1.camel@phoenix>
	<1320585411.18391.4.camel@phoenix>
Date: Mon, 7 Nov 2011 09:08:05 +0100
Message-ID: <CACRpkdaMFgoH41Wm31xJBxdATtnONrsamoBYbAhSO6UixGpKpQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] hwspinlock/u8500: include linux/module.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 2:16 PM, Axel Lin <axel.lin@gmail.com> wrote:

> Include module.h to fix below build error:

Thanks for always fixing our build errors Axel,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
