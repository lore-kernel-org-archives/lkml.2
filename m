Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0H3KbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:31:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39945 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab0H3KbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:31:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kiBN6LcZCz97vtHlrZc7Y5zOv9+81wB0irQMnw1mEBqWqToNGJNWl1UOa7QYg2XYB7
         lAFRNJopqPfASbeZK2fUPntbQF3q+rZq0vu2rKQbOs2BRBYfgwFT9GJsiLmzuyQAGlJp
         o5AipEICdLwu516oey7QgV9PdhXmZW1P5jkZk=
Subject: Re: [PATCH] mtd/ubi: cleanup and simplify Kconfig
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>, dwmw2@infradead.org
In-Reply-To: <201008191728.50871.hartleys@visionengravers.com>
References: <201008191728.50871.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 13:30:44 +0300
Message-ID: <1283164244.12995.46.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 17:28 -0700, H Hartley Sweeten wrote:
> Cleanup the Kconfig for UBI by using menuconfig to enable/disable the entire
> driver. Remove the dependency checks for MTD_UBI and MTD_UBI_DEBUG by
> wrapping the options in if/endif blocks and remove any redundant checks.
> Remove all default n since that is the Kconfig default. Change menu "Additional
> UBI debugging messages" into a comment to remove one menu level.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>

Pushed to ubi-2.6.git tree, thanks. There were some conflicts, I fixed
them, and you may verify if you wish. The tree:

http://git.infradead.org/ubi-2.6.git

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

