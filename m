Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2BAXRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:17:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52626 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2BAXRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:17:08 -0500
MIME-Version: 1.0
In-Reply-To: <d6bc8a99fb26a999ac17c793065333ccbf374b67.1328095280.git.JURGEN.HEEKS@NOKIA.COM>
References: <cover.1328095280.git.JURGEN.HEEKS@NOKIA.COM>
	<d6bc8a99fb26a999ac17c793065333ccbf374b67.1328095280.git.JURGEN.HEEKS@NOKIA.COM>
Date: Thu, 2 Feb 2012 08:17:06 +0900
Message-ID: <CAKYAXd9Z0=DsskRGeS9CcZYecYWkViAfE+Gf_FEaOfOdyUyaEA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmc:core: Fix comparison issue in mmc_compare_ext_csds
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jurgen Heeks <JURGEN.HEEKS@nokia.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/1 Jurgen Heeks <JURGEN.HEEKS@nokia.com>:
> Found this issue during code review. Actually, there are two
> issues which both compensate together in lucky case.
> In unlucky case the bus width probing might not work as expected.
>
> Signed-off-by: Jurgen Heeks <JURGEN.HEEKS@NOKIA.COM>
> ---
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>

Good catch!  Looks good to me.
Thanks.
