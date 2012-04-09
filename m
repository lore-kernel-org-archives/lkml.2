Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2DIIE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:04:59 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2964 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab2DIIE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:04:58 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4F829818.6040600@broadcom.com>
Date: Mon, 9 Apr 2012 10:04:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tso Ted" <tytso@mit.edu>, "Keith Packard" <keithp@keithp.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Stephen Hemminger" <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] module: Clarify usage of MODULE_LICENSE()
References: <1333903588-32608-1-git-send-email-mcgrof@frijolero.org>
In-Reply-To: <1333903588-32608-1-git-send-email-mcgrof@frijolero.org>
X-WSS-ID: 639C45E93E015379165-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2012 06:46 PM, Luis R. Rodriguez wrote:
>   include/linux/module.h |   17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index fbcafe2..8d36d86 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> - * This exists for several reasons
> + * The MODULE_LICENSE() exists for several reasons:
> + * 0.   So EXPORT_SYMBOL_GPL() allows the module to use its symbols

It seems there is some tab/space mixup here. Also not sure if the above 
statement is clear or correct. Correct me if I am wrong, but I thought 
it put a requirement on other modules to be able to use its symbols.

>    * 1.	So modinfo can show license info for users wanting to vet their setup
>    *	is free
>    * 2.	So the community can ignore bug reports including proprietary modules

Gr. AvS

