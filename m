Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0IPNYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:24:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32846 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0IPNX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=MW4mwyB8Res3CWq3OAbTBL010Drm/BojuL4VAmygNd4ujoV3iWqJr/ZnIHIyXI2uPW
         tw85kzF/NTq7kZ8/RiXJBAS08vrtg7cUVRulqO2cIqukS6cRiRHcsRGjMbT71yj/8rZ1
         mMN5+2xcgNjHvQFVJiuFI82mUiMDY56rxKo7k=
Date: Thu, 16 Sep 2010 15:23:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Vipin Mehta <Vipin.Mehta@Atheros.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/14] staging: ath6kl: check return code of get_user
	and put_user
Message-ID: <20100916132333.GA7867@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	Vipin Mehta <Vipin.Mehta@Atheros.com>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1283711550-7246-1-git-send-email-segooon@gmail.com> <35B17FE5076C7040809188FBE7913F983F2381DB98@SC1EXMB-MBCL.global.atheros.com> <20100916125908.GA4491@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916125908.GA4491@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 04:59:08PM +0400, Kulikov Vasiliy wrote:
> On Wed, Sep 08, 2010 at 22:59 -0700, Vipin Mehta wrote:
> > Hi Vasiliy,
> >     You mentioned in your email that you were unable to compile the driver. Can you pls reproduce a log of the errors you observed?
> 
> vasya@albatros:~/linux$ make allyesconfig && make drivers/staging/ath6kl/

CONFIG_STAGING=y
CONFIG_STAGING_EXCLUDE_BUILD=n

allyesconfig and allmodconfig don't include staging because to enable it
you need to say no to CONFIG_STAGING_EXCLUDE_BUILD.

I have a file called config-staging that includes the above lines.  Then
I do a:

KCONFIG_ALLCONFIG=config-staging make allmodconfig

regards,
dan carpenter
