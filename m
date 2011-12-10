Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab1LJOFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 09:05:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1LJOFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 09:05:48 -0500
Message-ID: <4EE36737.9070701@suse.cz>
Date: Sat, 10 Dec 2011 15:05:43 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: =?UTF-8?B?U2p1ciBCcsOmbmRlbGFuZA==?= 
	<sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv2 06/10] xshm: Add xshm device implementation
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com> <1323439648-22697-7-git-send-email-sjur.brandeland@stericsson.com>
In-Reply-To: <1323439648-22697-7-git-send-email-sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.12.2011 15:07, Sjur Brændeland wrote:
> +MODULE_VERSION("XSHM 0.6 : " __DATE__);

Please drop the __DATE__ macro, it results in builds that are not
reproducible.

Michal
