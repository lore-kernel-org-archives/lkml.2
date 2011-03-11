Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1CKViB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:38:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1CKVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:37:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mE/6cnuXouzPP3IdY6muEqnArHEV9L9/+oHS5DmQkCOvxElukdaU3nhc3ajOLym7uL
         HMXT4NicmM0pWHKpqvLJ0zfU67tpgiXZ5brL21xJ620u2W7h3TsXRDIU5BKdRZkKSpa/
         PjWpf2XCar7WP6hBDpM3/YryXi6E7HtUKw3so=
Date: Sat, 12 Mar 2011 00:37:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: Re: [PATCH 21/22] staging: xgifb: rename XGINew_SetRegANDOR() to
 xgifb_reg_and_or()
Message-ID: <20110311213740.GD2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	arnaud.patard@rtp-net.org
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
 <1299790967-7135-22-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299790967-7135-22-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 11:02:46PM +0200, Aaro Koskinen wrote:
> Rename XGINew_SetRegANDOR() to xgifb_reg_and_or().
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---

> -void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
> -		unsigned short DataAND, unsigned short DataOR)
> +void xgifb_reg_and_or(unsigned long port, u8 index, unsigned data_and,
                                             ^^^^^^^^  ^^^^^^^^^^^^^^^^^
> +		      unsigned data_or)
                      ^^^^^^^^^^^^^^^^
I wish the change log had mentioned some of these data type changes.  It
doesn't cause a bug, but it still should have been mentioned.

>  {
> -	unsigned short temp;
> +	u8 temp;

regards,
dan carpenter
