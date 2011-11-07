Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1KGIcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:32:04 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33142 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1KGIcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:32:02 -0500
MIME-Version: 1.0
In-Reply-To: <1320636009.10415.2.camel@phoenix>
References: <1320635954.10415.1.camel@phoenix>
	<1320636009.10415.2.camel@phoenix>
Date: Mon, 7 Nov 2011 09:32:01 +0100
Message-ID: <CACRpkdb9-k7u4d48UwAjxS-61Hk5gmStcjeHOWOFJzK3pJGZ5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: include linux/module.h for ab5500-debugfs
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

On Mon, Nov 7, 2011 at 4:20 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Include linux/module.h to fix below build error:

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Axel!
Linus Walleij
