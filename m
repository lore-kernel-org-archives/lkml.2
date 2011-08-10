Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab1HJN2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:28:30 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47100 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1HJN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:28:29 -0400
Date: Wed, 10 Aug 2011 16:24:33 +0300
From: Dan Carpenter <error27@gmail.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] staging: vme: make [alloc|free]_consistent bridge
 specific
Message-ID: <20110810132433.GA3777@shale.localdomain>
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>
 <1312968830-13377-3-git-send-email-manohar.vanga@cern.ch>
 <4E4257B6.6080109@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4257B6.6080109@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:04:38AM +0100, Martyn Welch wrote:
> On 10/08/11 10:33, Manohar Vanga wrote:
> > Make PCI dependent functions ([alloc|free]_consistent() in
> > 'vme.c') bridge specific. By removing the dependency of the
> > VME bridge framework on PCI, this patch allows for addition of
> > non-PCI based VME bridges.
> > 
> > Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
> 
> This appears to be resolving the issue raised by Dan. Assuming he's happy with
> this:
> 
> Acked-by: Martyn Welch <martyn.welch@ge.com>
> 

Yah yah.  Looks good.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

