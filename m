Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1FGMkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:40:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55356 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1FGMke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:40:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=l/VzPYrxB2rffNBydzD33h+uRk8ojybXn01CwhmtqysYgmmDdKHXPpNaAcPuN0Ccsi
         AxOHkrpEzhL95oWfsGdnve2o6YpQwpv1pZk8V8jd7x8vzcgbRH9HLqMh9z3eyisFjniV
         /uQ15UEMEtJfcY3QpcGk69A1k7JbJ81SpVNMY=
Message-ID: <4DEE1C3F.4070407@lwfinger.net>
Date: Tue, 07 Jun 2011 07:40:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Realtek RTL8192CU Polling FW ready fail!! REG_MCUFWDL:0x00000006
References: <BANLkTik84U0p7hf1+ofvPvJ2CO1MmutcWQ@mail.gmail.com> <BANLkTika3VUB6mmY=JLikQYgrFXk2xuP1A@mail.gmail.com>
In-Reply-To: <BANLkTika3VUB6mmY=JLikQYgrFXk2xuP1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2011 11:44 PM, Jeff Chua wrote:
>
>
> Not sure anyone got a chance to look into this. I could get the device
> to work with RTL8192CU_linux_v3.0.1590.20110511.zip (just that
> ifconfig wlan0 froze the whole system).
>
> rtw driver version=v3.0.1590.20110511
> CHIP TYPE: RTL8188C_8192C
> MAC Address from efuse= 00:22:cf:43:d3:8b

I have not yet had an opportunity to check on this. My recollection is that the 
error message from the firmware did not affect the operation of the chip, but I 
have not yet proved that.

I cannot vouch for the operation of any drivers downloaded from the Realtek web 
site. Many of them will not work with 64-bit systems.

Larry
