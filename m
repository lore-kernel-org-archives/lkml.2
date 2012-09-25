Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2IYPLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:11:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44195 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351Ab2IYPLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:11:06 -0400
X-Sasl-enc: dfuC6QAR0ehgTcHvPVSZdJNBDWsviFxZU6t2sEWZ3uUC 1348585864
Date: Tue, 25 Sep 2012 08:11:03 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Durgadoss R <durgadoss.r@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: manual merge of the staging tree with the thermal
 tree
Message-ID: <20120925151103.GB18777@kroah.com>
References: <20120925161355.06cfe875c78bc163b050ed8c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925161355.06cfe875c78bc163b050ed8c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 04:13:55PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/omap-thermal/omap-thermal-common.c between commit
> 82d3a76a88cd ("Thermal: Pass zone parameters as argument to
> tzd_register") from the thermal tree and commit 765a1939a364 ("staging:
> omap-thermal: fix polling period settings") from the staging tree.
> 
> I just used the thermal tree version and can carry the fix as necessary
> (no action is required).

That sounds correct to me, thanks.

greg k-h
