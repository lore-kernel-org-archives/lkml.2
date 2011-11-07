Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab1KGIL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:11:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61004 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1KGIL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <1320635954.10415.1.camel@phoenix>
References: <1320635954.10415.1.camel@phoenix>
Date: Mon, 7 Nov 2011 09:11:25 +0100
Message-ID: <CACRpkdapGnMqPRrrgy73V2gWMvv-LUGfmLqhXCDZxUJ2vsJozg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: include linux/module.h for ab5500-core
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 4:19 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Include linux/module.h to fix below build error:

Acked-by: Linus Walleij <linus.walleij@linaro.org>

For both.

Linus Walleij
