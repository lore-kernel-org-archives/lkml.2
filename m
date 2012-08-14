Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2HNQhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:37:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47764 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab2HNQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:37:11 -0400
Date: Tue, 14 Aug 2012 11:37:15 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>
Subject: Re: [GIT PULL] New TPM driver, hwrng driver and fixes
Message-ID: <20120814163715.GA1524@linux.vnet.ibm.com>
References: <20120727181436.GA6271@linux.vnet.ibm.com>
 <5029671A.70402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5029671A.70402@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081416-9360-0000-0000-0000096D1AE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 01:44:10PM -0700, H. Peter Anvin wrote:
> On 07/27/2012 11:14 AM, Kent Yoder wrote:
> > Hi James,
> > 
> > Please pull from this new branch and ignore the 7-25-12 branch. This
> > new branch includes fixes for comments by hpa. I've also included one
> > additional patch from [1] to close a race and prevent possibly sensitive
> > data from being free'd before being zeroed. I'm attaching this entire
> > diff here since my fixes for hpa's comments aren't public yet.
> > 
> > Thanks,
> > Kent
> > 
> > [1] https://lkml.org/lkml/2012/7/25/431
> > 
> 
> Hi guys,
> 
> I was wondering what the status on this tree is?

  Hi, I'm staging these patches against latest upstream and will be
hopefully adding another new driver and PPI patches from Intel on top,
to be included in a new pullreq for James.

Kent

> 
> 	-hpa
> 

