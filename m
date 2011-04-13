Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab1DMKCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:02:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58201 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab1DMKCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rgnEnTqLODAdLlge7GO1ySfEOI43P/6uSg+VKbS9vBOwqIggCkmg2OkcjY2f0Q5ky5
         gyr6cjc/IqXupfj2vkzPjgsYSWcx1u85gNib/MouJMXRjig7XPKskcwhz0EAChJUtf3o
         +LCh2jHaBCDf1QIOu9kIlZADfpwa5MqlgIrxI=
Message-ID: <4DA574C7.6050904@gmail.com>
Date: Wed, 13 Apr 2011 12:02:47 +0200
From: "=?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?=" <andreas.devel@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <biessmann@corscience.de>
CC: kernel@avr32linux.org,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] avr32: add ATAG_BOARDINFO
References: <1302682057-6244-1-git-send-email-biessmann@corscience.de>
In-Reply-To: <1302682057-6244-1-git-send-email-biessmann@corscience.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.04.2011 10:07, schrieb Andreas Bießmann:
> The ATAG_BOARDINFO is intended to hand over the information
> bd->bi_board_number from u-boot to the kernel.
> 
> This piece of information can be used to implement some kind of board
> identification while booting the kernel. Therefore it is placed in .initdata
> section and can be accessed via the new symbol board_number only while
> initializing the kernel.

Tested with mainline u-boot plus patch
http://article.gmane.org/gmane.comp.boot-loaders.u-boot/97573 on atstk1002.

regards

Andreas Bießmann
