Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1H2O5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:57:44 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:48535 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1H2O5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:57:41 -0400
Date: Mon, 29 Aug 2011 10:57:27 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: vme: add struct vme_dev for VME devices
Message-ID: <20110829145727.GC9952@flamenco.cs.columbia.edu>
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-3-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314608570-32766-3-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:02:49 +0200, Manohar Vanga wrote:
> Instead of using a vanilla 'struct device' for VME devices, add new
> 'struct vme_dev'. Modifications have been made to the VME framework
> API as well as all in-tree VME drivers.
> 
> The new vme_dev structure has the following advantages from the
> current model used by the driver:
> 
>     * Driver functions (probe, remove) now receive a VME device
>       instead of a pointer to the bridge device (cleaner design)
>     * It's easier to differenciate API calls as bridge-based or
>       device-based (ie. cleaner interface).
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Reviewed-by: Emilio G. Cota <cota@braap.org>

