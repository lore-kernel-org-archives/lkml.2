Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1HVNUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:20:31 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35594 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1HVNU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:20:29 -0400
Date: Mon, 22 Aug 2011 09:20:18 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry (v2)
Message-ID: <20110822132018.GB12337@hmsreliant.think-freely.org>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110808191354.GA22117@hmsreliant.think-freely.org>
 <20110810133158.GB7598@amd.com>
 <20110822104621.GA12337@hmsreliant.think-freely.org>
 <20110822124427.GE2079@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822124427.GE2079@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.2 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 02:44:27PM +0200, Roedel, Joerg wrote:
> Hi Neil,
> 
> On Mon, Aug 22, 2011 at 06:46:21AM -0400, Neil Horman wrote:
> 
> > Hey, Jeorg, just wondering if you managed to get a look at this?
> > Neil
> 
> It is not forgotten :) This is my first day back in office and I will
> look into it today.
> 
Ah, apologies, I'm just getting back from vacation myself, and am trying to
figure out where I left off with everything :)
Neil

> Joerg
> 
> -- 
> AMD Operating System Research Center
> 
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632
> 
> 
