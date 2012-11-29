Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2K2QIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:08:15 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58371 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab2K2QIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:08:14 -0500
Date: Thu, 29 Nov 2012 10:06:27 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char/tpm: Use true and false for bools
Message-ID: <20121129160627.GB15399@ennui.austin.ibm.com>
References: <1354148437-6446-1-git-send-email-peterhuewe@gmx.de>
 <20121129002519.GG4939@ZenIV.linux.org.uk>
 <201211290142.47502.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211290142.47502.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112916-7182-0000-0000-00000369BD33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:42:47AM +0100, Peter Huewe wrote:
> Am Donnerstag, 29. November 2012, 01:25:19 schrieb Al Viro:
> > On Thu, Nov 29, 2012 at 01:20:37AM +0100, Peter Huewe wrote:
> > > -		itpm = (probe == 0) ? 0 : 1;
> > > +		itpm = (probe == 0) ? false : true;
> > 
> > Charming.  Not that original had been better, but...
> Yeah. Sorry it's late.
> The tpm subsection has a lot of nice suprises.

 :-)  I'd prefer

 itpm = !!probe;

 Now I don't have to go look up what the possible return values of
probe_itpm() are...

Kent

> I changed it to itpm = probe; which is equivalent here and sent out a v2.
> I'll probably rewrite that code section anytime soon.
> 
> Thanks for noticing.
> Peter
> 

