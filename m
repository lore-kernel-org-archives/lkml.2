Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab0I2Kxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 06:53:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36574 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0I2Kx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 06:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ksR7wtFZvxroFA6q2n+Qv4yxqKan+TVsiMtY/RKkHbIpx2gycwusE3YxYYg7GGiXJA
         5amSn4dyKnHIQ1sQtH2+UVTKC1cd+iWfmIHSfYAAcYjPV9knpF1lbmxrl1xW9KWxa57K
         xT9t/LUK9FI5jIXEr4IA94kTF0c+6PmXoVlVg=
Message-ID: <4CA31AA6.7020003@gmail.com>
Date: Wed, 29 Sep 2010 12:53:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: ioremap definition in generic io.h
References: <1285747145.12259.3.camel@needafix>
In-Reply-To: <1285747145.12259.3.camel@needafix>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2010 09:59 AM, Jonas Bonn wrote:
> I'm wondering about the usefulness of the definition of ioremap and
> __ioremap in asm-generic/io.h.  How is this intended to be used?  How
> are the page tables for this mapping supposed to be constructed?

Which page tables? The functions there are for machines w/o MMU with 1:1
phys:virt mapping.

regards,
-- 
js
