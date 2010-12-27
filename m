Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0L0UTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 15:19:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57318 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0L0UTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 15:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=qql4l4LLu2XHBRpV0DTvspOghJ2Thv58tdCtsU0NOXvU+809Mxswsr4TH0bFyvzVkU
         IXHjFQTxFCbh2CEM078asB09e9z6QyWi3C+qgBixAXxrXmv9LHKn4lGgnJf+kHhovgQ4
         69fU34HAUpDm/HMfwWwqszUWNXuBAzAxbjtpI=
Date: Mon, 27 Dec 2010 23:19:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: mcarlson@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH] tg3: fix return value check in tg3_read_vpd()
Message-ID: <20101227201927.GA6365@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Sterba <dsterba@suse.cz>, mcarlson@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michael Chan <mchan@broadcom.com>
References: <1293471094-28976-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293471094-28976-1-git-send-email-dsterba@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 06:31:34PM +0100, David Sterba wrote:
> CC: Matt Carlson <mcarlson@broadcom.com>
> CC: Michael Chan <mchan@broadcom.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---

Your fix is obviously correct, but could you describe the symptoms
in your changelog instead of leaving it blank?  In the original code,
negative error values are ignored so we never goto out_not_found.  Can
pci_read_vpd() return any errors we care about besides -ENODEV?  What I
mean is, did you find this through analysing the code or did it cause a
bug at runtime?

regards,
dan carpenter

