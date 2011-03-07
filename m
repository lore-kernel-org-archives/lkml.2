Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab1CGSu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:50:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39025 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab1CGSu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:50:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=V1siMgdmz2pyp1sQVI6FzyWxTTtCAhIDwmo3wRdT3kpWmSteCPPGCAQAKBSat5CQYD
         cSiVHuUiolThSV67WHOVtKhyDrR3xYPSeD0lnFtQzjxKuJ6FvXRuhAGUg0jTAxSAn/gn
         rAcI5aBnRkiHWOQaCViJ8kcS+lJtgnkC8Ed8g=
Date: Mon, 7 Mar 2011 21:50:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: wei_wang@realsil.com.cn
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rts_pstor: MSXC card power class
Message-ID: <20110307185001.GX3416@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	wei_wang@realsil.com.cn, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
References: <1299485461-3941-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299485461-3941-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 04:11:01PM +0800, wei_wang@realsil.com.cn wrote:
>  #ifdef XC_POWERCLASS
> -	u8 change_power_class = 2;
> +	u8 change_power_class;
> +
> +	if (chip->ms_power_class_en & 0x02) {
> +		change_power_class = 2;
> +	} else if (chip->ms_power_class_en & 0x01) {
> +		change_power_class = 1;
> +	} else {
> +		change_power_class = 0;
> +	}

This makes scripts/checkpatch.pl complain.

regards,
dan carpenter


