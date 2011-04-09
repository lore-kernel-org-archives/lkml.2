Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab1DIN1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 09:27:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50312 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1DIN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 09:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ao+tdBi1QZUxpf7rv8EbRus5ZrBKFmfTFlz5CL+sVOwU/0StfwX4uqYJn2OnKrT6WU
         E8Ffg6Q93frvlz7+gqsfr9zxKbiF505bzw/jxGH6A9m6EsiKmQHiuRlXY3y0d0W8hYcb
         /21aGvNSrNGLpAIG3fP9R7sHsti5qCUlqHJDA=
Message-ID: <4DA05EA3.5080008@gmail.com>
Date: Sat, 09 Apr 2011 15:26:59 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] char: istallion: fix arbitrary kernel memory reads/writes
References: <1302352882-20802-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1302352882-20802-1-git-send-email-segoon@openwall.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2011 02:41 PM, Vasiliy Kulikov wrote:
> stli_brdstats is defined as global variable.  After de-BKL-ization in
> the patch b4eda9cb48eac1b7 an access to the variable is not serialized
> anymore.  This leads to the TOCTOU in stli_getbrdstats():

Don't use such a weird and uncommon abbreviations.

> --- a/drivers/char/istallion.c
> +++ b/drivers/char/istallion.c

Note that the code moved to staging.

regards,
-- 
js
