Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1IUS6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:58:22 -0400
Received: from void.printf.net ([89.145.121.20]:50187 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab1IUS6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:58:13 -0400
From: Chris Ball <cjb@laptop.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mmc: rectify boot param option for fault injection
References: <1316002218-3408-1-git-send-email-per.forlin@linaro.org>
Date: Wed, 21 Sep 2011 14:57:58 -0400
In-Reply-To: <1316002218-3408-1-git-send-email-per.forlin@linaro.org> (Per
	Forlin's message of "Wed, 14 Sep 2011 14:10:15 +0200")
Message-ID: <m2mxdx205k.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Per,

On Wed, Sep 14 2011, Per Forlin wrote:
> Akinobu Mita reported that the boot option for mmc fault injection is never
> compiled in due to a fauly "ifdef KERNEL" that is never set.
> A correct ifdef would be "ifndef MODULE". This patch set adds a
> module_param_cb() and thereby no ifndef MODULE is needed.
> Using a module_param makes it possible to pass default fault attributes for
> external modules too.

Thanks, all merged to mmc-next for 3.2 with Akinobu-san's Reviewed-by.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
