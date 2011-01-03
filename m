Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1ACKlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:41:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48962 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1ACKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cXb7gPBoOw/JemFxz40flyXh6mbGaIcoC5IGPD7QPIPhS9jWvw0VEkBZFgXXDxPTAc
         1+xAGciZF7AW7rairxWfQxXiYrrENY3guPyw9yeBiOaSZWlbXKtJWPYlkJqYkxboZpfd
         rIynPKS9n6OAgk5MrYgZ48Oi6CZqqA6cGZAiU=
Message-ID: <4D21A7E8.3090709@gmail.com>
Date: Mon, 03 Jan 2011 11:41:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org
Subject: Re: [34-longterm 000/260] v2.6.34.8 longterm review
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2011 08:14 AM, Paul Gortmaker wrote:
> This is the start of the longterm review cycle for the v2.6.34.8 release.
> There are 260 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

Hi, although I'm neither of that, I'm missing tty fixes. Please see:
https://lkml.org/lkml/2010/11/29/508
and add the three in the next round.

thanks,
-- 
js
