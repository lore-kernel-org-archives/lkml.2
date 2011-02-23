Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab1BWPQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:16:33 -0500
Received: from cernmx32.cern.ch ([137.138.144.178]:25573 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1BWPQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:16:32 -0500
Date: Wed, 23 Feb 2011 16:16:18 +0100
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: Dan Carpenter <error27@gmail.com>, <devel@driverdev.osuosl.org>,
        <cota@braap.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Staging: vme: remove unreachable code
Message-ID: <20110223151618.GA27806@becoht-mvanga>
References: <1298403376-28352-1-git-send-email-manohar.vanga@cern.ch>
 <1298403376-28352-2-git-send-email-manohar.vanga@cern.ch>
 <4D64D10A.3070702@ge.com>
 <20110223121726.GR1898@bicker>
 <4D652344.1020402@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D652344.1020402@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There are two problems with this loop.  1) It unregisters the device
> > which failed to register.  2) It is a forever loop.
> > 
> 
> Even if "i" is a signed int?

The infinite loop is because "i" is not decremented anywhere in the loop. Not
because of signedness.

Thanks,
Manohar Vanga
