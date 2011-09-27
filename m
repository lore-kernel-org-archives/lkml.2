Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab1I0QK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:10:26 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:56191 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1I0QKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:10:25 -0400
Date: Tue, 27 Sep 2011 12:10:09 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110927161009.GA26241@flamenco.cs.columbia.edu>
References: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
 <1317029238-13357-3-git-send-email-manohar.vanga@cern.ch>
 <20110926232906.GB13175@flamenco.cs.columbia.edu>
 <20110927080824.GB17775@becoht-mvanga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927080824.GB17775@becoht-mvanga>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Sep 27, 2011 at 10:08:24 +0200, Manohar Vanga wrote:
> It _does_ acquire the lock. The patch here doesn't show it:

Great, then it's all hunky dory. Feel free to add:
   Reviewed-by: Emilio G. Cota <cota@braap.org>
to the series.

Thanks!

                Emilio

