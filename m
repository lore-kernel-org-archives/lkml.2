Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1BBBXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:23:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43603 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1BBBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 20:23:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=or+ZdnHGiHsvkZo1IQOWNIaaifFa4vs2otSaVHvL0nrMjRqci1WTP73NXN5BExv5W3
         HlLpCo9eWoxqU7871WqyndmpqMkWq641mdpcdaNaaXQ3qrLbm3Ndtwu3uH9HiSCs05YX
         EUZdepTgKxiHu6uAJ0I10cluUd6r3gG89qmx0=
Message-ID: <4D48B24B.8020305@lwfinger.net>
Date: Tue, 01 Feb 2011 19:24:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Mark Einon <mark.einon@gmail.com>
CC: greg@kroah.com, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8712: Switch from large inline firmware file
 to use the firmware interface
References: <1296607614-5326-1-git-send-email-mark.einon@gmail.com>
In-Reply-To: <1296607614-5326-1-git-send-email-mark.einon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 06:46 PM, Mark Einon wrote:
> As per the drivers/staging/rtl8712/TODO file. Relevant firmware
> already present in linux-firmware package.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> ---
>  drivers/staging/rtl8712/farray.h   |10197 ------------------------------------
>  drivers/staging/rtl8712/hal_init.c |   36 +-
>  2 files changed, 16 insertions(+), 10217 deletions(-)
>  delete mode 100644 drivers/staging/rtl8712/farray.h

The equivalent of this patch was sent to GregKH on January 14,

Larry
