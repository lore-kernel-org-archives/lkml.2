Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0HPSgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:36:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33030 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab0HPSgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=pnh0V/+tnMgz2xW08NfFGCmNFG/wDsfiobsc20bxSBIAlzllea3nICjWd73Bn40ifR
         1E3rfo5pDkhDE7teDVeVojZRCfPZ1lLdxMAKKdO4olMCeJFc7gBbcQhcwLsMu5aR+0tm
         tF9afiST7oa7j4HzbPTfeKcb02F3makv2tGtQ=
Date: Mon, 16 Aug 2010 20:35:40 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Amit Kumar Salecha <amit.salecha@qlogic.com>,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 16/16] drivers/net/qlcnic: Use available error codes
Message-ID: <20100816183540.GE645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	Amit Kumar Salecha <amit.salecha@qlogic.com>,
	Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
	linux-driver@qlogic.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008161828520.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008161828520.19313@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 06:29:13PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The error code is stored in the variable err, but it is the variable ret
> that is returned instead.  So store the error code in ret.  Err is then
> useless.

Could you redo this for the latest git?  (Sorry, I recently made the
problem slightly worse by adding another "err = -ENOMEM;")...

regards,
dan carpenter

