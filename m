Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1H2O44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:56:56 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:52827 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab1H2O4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:56:53 -0400
Date: Mon, 29 Aug 2011 10:56:32 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110829145632.GB9952@flamenco.cs.columbia.edu>
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-2-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314608570-32766-2-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:02:48 +0200, Manohar Vanga wrote:
> This patch adds functions that allow for reference counting
> bridge modules. The patch introduces the functions
> 'vme_bridge_get()' and 'vme_bridge_put()'.
> 
> The functions are automatically called during .probe and .remove
> for drivers.
> 
> This patch is based on the changes introduced by Emilio G. Cota
> in the patch:
> 
>     https://lkml.org/lkml/2010/10/25/492
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Reviewed-by: Emilio G. Cota <cota@braap.org>

