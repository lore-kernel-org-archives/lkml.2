Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0HaMwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:52:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49632 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0HaMwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Q5zk2JnQDQA2wRFbnu/yIX0hynt0m+bguhplhayAEeIHVcdaim++lymdH5W9YjHrF8
         Qe6VPIRn4NqBIiOWW+FSRh0THcEFHyPYC4quwv9TrYvP0ONoBCBQW5pm5ECJvhEt37LT
         7TtqPe3DPWkPzQvwo9gu0iNSoNLN7FBGkG2mM=
Message-ID: <4C7CFAEA.2040408@gmail.com>
Date: Tue, 31 Aug 2010 14:51:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
CC: linux-kernel@vger.kernel.org, listar@nl.linux.org
Subject: Re: increasing memory alloted for 'init' during kernel boot.
References: <AANLkTimWnYqFSC=3kqzBVtZHwodCX=MnsViDGmJbUn_8@mail.gmail.com>	<4C7CBBBC.3070503@gmail.com> <AANLkTiniKYm7krr1j48VbV7oNDA7YKXzTnuCZ9kOMnUs@mail.gmail.com>
In-Reply-To: <AANLkTiniKYm7krr1j48VbV7oNDA7YKXzTnuCZ9kOMnUs@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 10:43 AM, Prabhu Chawandi wrote:
> Hi ,
> 
> Thanks for the info...
> 
> Problem I am facing is, I have two bootloaders, when I boot from one
> loader booting happens properly.
> 
> but when I try to load from other loader, kernel does not boot, it
> crashes. When i saw the boot logs, I saw that I memory allocated to
> 'init' section in case of crash is short by almost 5MB to the normal
> boot log.
> 
> I am using mips processor.
> 
> Any idea, why this might be happening ?

The bad loader probably loads the image wrong (incorrect data or not
whole image).

regards,
-- 
js
