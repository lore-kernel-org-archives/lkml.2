Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946111Ab2K2Amm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:42:42 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60374 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932620Ab2K2Aml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:42:41 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18S6rInqoASEorA8/CxafybPbppKIQye0sFaK28vv
	z9NOKE5/75wvV2
From: Peter Huewe <PeterHuewe@gmx.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] char/tpm: Use true and false for bools
Date: Thu, 29 Nov 2012 01:42:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.7; KDE/4.8.5; x86_64; ; )
Cc: Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1354148437-6446-1-git-send-email-peterhuewe@gmx.de> <20121129002519.GG4939@ZenIV.linux.org.uk>
In-Reply-To: <20121129002519.GG4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211290142.47502.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 29. November 2012, 01:25:19 schrieb Al Viro:
> On Thu, Nov 29, 2012 at 01:20:37AM +0100, Peter Huewe wrote:
> > -		itpm = (probe == 0) ? 0 : 1;
> > +		itpm = (probe == 0) ? false : true;
> 
> Charming.  Not that original had been better, but...
Yeah. Sorry it's late.
The tpm subsection has a lot of nice suprises.

I changed it to itpm = probe; which is equivalent here and sent out a v2.
I'll probably rewrite that code section anytime soon.

Thanks for noticing.
Peter
