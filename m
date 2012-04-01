Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab2DAJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 05:26:25 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60731 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2DAJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 05:26:23 -0400
Date: Sun, 1 Apr 2012 11:26:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update EDAC information
Message-ID: <20120401092616.GB15717@aftab>
References: <20120331100214.GA7256@aftab>
 <mailman.285955.1333149246.6384.bluesmoke-devel@lists.sourceforge.net>
 <4F7642A9.2070801@tilera.com>
 <201203311350.q2VDoO23007327@farm-0012.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203311350.q2VDoO23007327@farm-0012.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 09:46:03AM -0400, Chris Metcalf wrote:
> The bluesmoke mailing list no longer works, so use
> linux-edac@vger.kernel.org.  And, use a less restrictive pattern so all
> drivers/edac changes go to linux-edac as well.
> 
> Borislav suggested I just push this through the tile tree since there
> is currently no core edac maintainer (emails to Doug Thompson bounce).
> 
> Reviewed-by: Borislav Petkov <bp@amd64.org>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Please don't add Reviewed-by tags to a patch which actually hasn't been
reviewed yet, no matter how trivial it is.

Other than that:

Acked-by: Borislav Petkov <bp@amd64.org>

Thanks for doing that.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
