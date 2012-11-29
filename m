Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2K2WQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:16:46 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:38344 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753766Ab2K2WQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:16:45 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/ACdcCZsHACb7jA5hugxVCPdNDBiGejoHP6YESz8
	tePBH2SveV+D2C
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] char/tpm: Use true and false for bools
Date: Thu, 29 Nov 2012 23:16:55 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.7; KDE/4.8.5; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20121129160627.GB15399@ennui.austin.ibm.com> <1354226092.1700.8.camel@joe-AO722> <20121129220811.GA32514@ennui.austin.ibm.com>
In-Reply-To: <20121129220811.GA32514@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211292316.55305.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 29. November 2012, 23:08:11 schrieb Kent Yoder:
> On Thu, Nov 29, 2012 at 01:54:52PM -0800, Joe Perches wrote:
> > > 
> > > -		itpm = (probe == 0) ? 0 : 1;
> > > +		itpm = !!probe;
> > 
> > Even more trivia:
> > 
> > This !! isn't necessary as ints assigned to bool are converted
> > by the compiler to 0 or 1.
> 
>   Good to know, thanks Joe!

So v2 is fine.

Peter
