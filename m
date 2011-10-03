Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1JCIgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:36:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47902 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1JCIgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <20111002202255.GA6991@elgon.mountain>
References: <20111002202255.GA6991@elgon.mountain>
Date: Mon, 3 Oct 2011 10:36:42 +0200
Message-ID: <CACRpkdZ8qdbTZshFyuYaeDVfUSb2j0AkNid-N=WRVRZpqaRSWg@mail.gmail.com>
Subject: Re: [patch] pinctrl: double free on error path in pinctrl_register()
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 10:22 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This is duplicated in the error handling after we go to out_err.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This got fixed by Axel Lin's patch that arrived just a little bit
before this one,
but thanks anyway!

Yours,
Linus Walleij
