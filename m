Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2IXIzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:55:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16904 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2IXIzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:55:36 -0400
Date: Mon, 24 Sep 2012 11:55:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: yvahk-xreary@zacglen.net
Cc: dheitmueller@kernellabs.com, linux-kernel@vger.kernel.org,
        mijhail.moreyra@gmail.com, stoth@kernellabs.com
Subject: Re: Freeze or Oops on recent kernels
Message-ID: <20120924085528.GJ4587@mwanda>
References: <20120924063641.GB28937@mwanda>
 <201209240652.q8O6qWGf012411.zacglen.com@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209240652.q8O6qWGf012411.zacglen.com@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 04:52:32PM +1000, yvahk-xreary@zacglen.net wrote:
> >
> >HINT: We only care about the very most recent kernel.  If you can
> >take a photo of the stack trace, then file a bug report and attach
> >the .jpg.
> >
> 
> After a bit of experimentation my guess is that is is all
> about bad Intel DX58SO2 motherboard.
> 
> And my guess is that it has something to do with memory
> mapping during an interrupt. Don't know much about memory
> mapping but I suspect that something quite fundamental
> goes wrong with this motherboard only.
> 
> Exact same type of oops also happens with a PCIe RS232 serial card.
> 

There is not enough information here for us to help you.  Sorry.

regards,
dan carpenter

