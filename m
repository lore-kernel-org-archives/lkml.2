Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab0I0PaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:30:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab0I0P37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:29:59 -0400
Date: Mon, 27 Sep 2010 11:29:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 1/7] x86, NMI, Add symbol definition for NMI magic
 constants
Message-ID: <20100927152947.GA26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <20100927105015.GL13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927105015.GL13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 12:50:15PM +0200, Robert Richter wrote:
> On 26.09.10 20:57:00, Huang Ying wrote:
> > Replace the NMI related magic numbers with symbol constants.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> Reviewed-by: Robert Richter <robert.richter@amd.com>
> 
> See my comments to patches 3, 4, 6, 7.

Thanks!

Cheers,
Don
