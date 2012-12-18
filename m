Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2LRShs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:37:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46926 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754966Ab2LRShr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:37:47 -0500
Message-ID: <1355855866.30366.21.camel@joe-AO722>
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jacob Shin <jacob.shin@amd.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 10:37:46 -0800
In-Reply-To: <20121218183330.GH31255@liondog.tnic>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
	 <1355773188-5241-2-git-send-email-jacob.shin@amd.com>
	 <20121218171915.GE31255@liondog.tnic> <1355855069.30366.14.camel@joe-AO722>
	 <20121218183330.GH31255@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 19:33 +0100, Borislav Petkov wrote:
> On Tue, Dec 18, 2012 at 10:24:29AM -0800, Joe Perches wrote:
> > or without all the unnecessary parens and using char:
> > 
> > 			pr_cont("%cBUFF parity error\n", xec == 4 ? 'I' : 'O');
> 
> Char is fine, the parens make this more readable when you look at it
> again after a couple of months :-).

<shrug>

I think the unnecessary parens make it _less_ readable
because you need to parse more stuff and it's easy to
misplace those parens.

cheers, Joe

