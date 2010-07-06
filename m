Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0GFPfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:35:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0GFPfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:35:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: Problem with tty changes in linux-next
Date: Tue, 6 Jul 2010 17:35:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: Luotao Fu <l.fu@pengutronix.de>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ilya Dryomov <idryomov@gmail.com>
References: <20100706130403.GD3991@pengutronix.de> <201007061623.48363.arnd@arndb.de> <20100706151454.GB12444@suse.de>
In-Reply-To: <20100706151454.GB12444@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007061735.02881.arnd@arndb.de>
X-Provags-ID: V02:K0:32L9haKU0wW9Ed8Yr+kjYVoR/pHvOym0SU1hQ2hxcuz
 XUG2a1pmhYWJVzqaVWoHSCTmLcLTgLf8AaxtLydb7QtNx5TUFh
 dTXuK7pRFJBGWxOyRk/yDsd5CT/Z7vD5PKwQVovSXfBmejp2Am
 dEZEvgtWLNO1/MPxaMqigK/FwbbofHVHkQwccG9Cok/RpDQPnq
 drjDQ9OiIeT2Nzcbmku/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 July 2010 17:14:54 Greg KH wrote:
> I should get to this today and push it into the next
> linux-next release.

Ok, thanks!

On Tuesday 06 July 2010 16:40:52 Ilya Dryomov wrote:
> I had the same issue. Here is the patch:
> 
> https://patchwork.kernel.org/patch/108700/

Yes, that's the one. It would be good to get another confirmation
from Luotao Fu that this fixes all the problems with missing characters.
As I mentioned, the boot-time warning will get taken care of by
a different patch, but can be safely ignored.

	Arnd 
