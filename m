Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1AYMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:25:58 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37429 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1AYMZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:25:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=okUAU1nnXJ/TL0XqTZ9rdBFrKYiTgq6oqljRSXIbD1JcmXLLCiednK+SVIeIE3nRWG
         zJMBKU/9C43q0FXKcvTDcM08cMmtydoYsDsoqmCmLsO2wNfV2fPobObgEJiec1CnCHST
         snFSSv2C0NSRmLBd+vzIUP7dkJPAxQQOi7rSE=
Date: Tue, 25 Jan 2011 15:25:29 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 08/12] staging: ft1000: Fix coding style in
 get_request_type_usb() function.
Message-ID: <20110125122529.GF2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
 <1295955083-11086-8-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295955083-11086-8-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
>  {
> -   u16   request_type;
> -   u32    status;
> -   u16   tempword;
> -   u32    tempx;
> +	u16   request_type;
> +	u32    status;
> +	u16   tempword;
> +	u32    tempx;
              ^^
Whacky.

regards,
dan carpenter
