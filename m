Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab2CHVrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:47:41 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47988 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab2CHVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:47:39 -0500
Date: Thu, 8 Mar 2012 14:47:38 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Greg KH <greg@kroah.com>
cc: Aneesh V <aneesh@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/8] Add TI EMIF SDRAM controller driver
In-Reply-To: <20120308205944.GB16644@kroah.com>
Message-ID: <alpine.DEB.2.00.1203081443030.9551@utopia.booyaka.com>
References: <1331222065-3579-1-git-send-email-aneesh@ti.com> <20120308205944.GB16644@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, Greg KH wrote:

> On Thu, Mar 08, 2012 at 09:24:17PM +0530, Aneesh V wrote:
>
> > The driver will need some minor updates when it is eventually
> > integrated with Dynamic Voltage and Frequency Scaling (DVFS).
> > This can not be done now as DVFS support is not available in
> > the mainline yet.
> 
> What will need to be updated in it?  The userspace interface or
> something else?
> 
> Why not wait until that code is accepted, it should be going into 3.4,
> right?

DVFS for the ARM cores is going in for 3.4 - that's not what Aneesh is 
referring to.  The changes here pertain to DVFS for core devices.  Core 
devices include the EMIF as well as several other devices.  Core DVFS is 
much more challenging to implement cleanly.  It has clock framework and 
driver dependencies.  So it probably won't be ready for several months at 
the very least.


- Paul
