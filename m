Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab1CaS2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:28:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47974 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab1CaS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:28:08 -0400
Message-ID: <4D94C7B3.4040307@canonical.com>
Date: Thu, 31 Mar 2011 13:28:03 -0500
From: Manoj <manoj.iyer@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Bagwell <chris@cnpbagwell.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        pingc@wacom.com
Subject: Re: [PATCH] add support for Lenovo tablet ID (0xE6)
References: <1301592052-4064-1-git-send-email-manoj.iyer@canonical.com>	<1301592052-4064-2-git-send-email-manoj.iyer@canonical.com>	<20110331174334.GA414@core.coreip.homeip.net>	<AANLkTi=a1eZS2fjxKYzf1RsE=6n9wZwUTPs8v84zb6p_@mail.gmail.com>	<20110331180632.GB414@core.coreip.homeip.net> <AANLkTinB6GnF4gsX=-hXSLy9M1pUG1Y4W-sD_=4jdODi@mail.gmail.com>
In-Reply-To: <AANLkTinB6GnF4gsX=-hXSLy9M1pUG1Y4W-sD_=4jdODi@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ah, yes.  There it is.
>
> The for-linus and next branches are quite different in this area of
> file.  The patch of this email would not apply cleanly to for-linus.
>
> My suggestion is to use value of 0xE3 for which ever branch this is
> merged to... but best for Ping to ack.

Chris,

Just to confirm, so base the patch on the for-linus tree and use the 
values as in 0xE3? is that correct? I will put Ping to ack as well.

>
> Chris
>
