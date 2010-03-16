Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682Ab0CPNEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:04:13 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:32907 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0CPNEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=h/NcMKDg+OQyxVX0u/2a33EOR8qiK+/qTaAaw6Su6ce6XD0hUyUNBm7p6WiPrtnHbc
         bCT0vfXpEuKR8o+5r6s9pyVAlQwhWdAlFNtT0VbJWW7cLe/ZqE7qKtgheB9lhqMBadMf
         OlAcd3I3upkDI3hzJCexeIZeKUX0T15UP+aQk=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: greg@kroah.com
Cc: Kay Sievers <kay.sievers@vrfy.org>, Michael Tokarev <mjt@tls.msk.ru>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: support !CONFIG_TMPFS
References: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk>
	<4B9A2548.7050401@msgid.tls.msk.ru>
	<87aaud22jj.fsf@macbook.be.48ers.dk>
	<ac3eb2511003120502y2953ff0au81ee5c4d76261a87@mail.gmail.com>
Date: Tue, 16 Mar 2010 14:04:06 +0100
In-Reply-To: <ac3eb2511003120502y2953ff0au81ee5c4d76261a87@mail.gmail.com>
	(Kay Sievers's message of "Fri, 12 Mar 2010 14:02:57 +0100")
Message-ID: <87tysgifjt.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kay" == Kay Sievers <kay.sievers@vrfy.org> writes:

Hi,

 Kay> For the patch:
 Kay>   Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Great - Greg, will you pick this up?

http://patchwork.kernel.org/patch/85237/

-- 
Bye, Peter Korsgaard
