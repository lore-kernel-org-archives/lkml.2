Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0FWUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab0FWUBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:01:37 -0400
Date: Wed, 23 Jun 2010 16:00:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100623200048.GR5381@redhat.com>
References: <20100621122145.76ebd7ac.akpm@linux-foundation.org>
 <20100621194559.GI3217@redhat.com>
 <20100621130008.d3dc01a8.akpm@linux-foundation.org>
 <20100622153457.GA5381@redhat.com>
 <20100622164835.4ddb9432@lxorguk.ukuu.org.uk>
 <20100622163817.GE20668@srcf.ucam.org>
 <20100622175741.6541ff2a@lxorguk.ukuu.org.uk>
 <20100622170410.GA22182@srcf.ucam.org>
 <20100623030637.GA30139@linux-sh.org>
 <20100623033047.GA32644@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623033047.GA32644@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 04:30:47AM +0100, Matthew Garrett wrote:
> I don't think it's a flag that would ever be used in mainline, and 
> Alan's suggestion to just keep a range of taint flags as vendor-specific 
> would avoid the risk of collisions in future. But there's a minor 
> incentive to maintain standardisation over these things in order to 
> encourage commonality of report code.

Exactly.  This was why we posted this upstream to see if there were other
distros interested in a mechanism like this.

Cheers,
Don
