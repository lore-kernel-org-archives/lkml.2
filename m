Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab0D3Rca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:32:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34090 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330Ab0D3RcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=uL0LHwP9FEfMYJeQnHvK1v4kX/u2Hfu7SJRF9s1GgeXn1dh7RVAe9DkObutV/3SDfT
         2WyAkM/QQF/yJa8w9x890PZw3o9c9lvtghm1QPykv/1idEz4sKhJNe1Md4Ef/SImvgkL
         +E14UeOwCve1eHD582jnwnsKRzEANO3PA6ol8=
Date: Thu, 29 Apr 2010 11:29:57 +0200
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Ortiz, Samuel" <samuel.ortiz@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] iwl: cleanup: remove unneeded error handling
Message-ID: <20100429092956.GH29093@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>, "Ortiz, Samuel" <samuel.ortiz@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <20100428090115.GF29093@bicker> <1272507134.14773.4339.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272507134.14773.4339.camel@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 10:12:14AM +0800, Zhu Yi wrote:
> 
> Thanks. But looks like you missed the one in if_sdio_debugfs_init().
> 

Yup.

> I don't think we even need to check -ENODEV ourselves because if
> DEBUG_FS is not compiled in, all the debugfs utility functions will
> become no-op.
> 

Good point.

> Signed-off-by: Dan Carpenter <error27@gmail.com>

Probably this could get changed to just "Reported-by" but I'm happy to
take credit for other peoples work.  :)

> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> 

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

