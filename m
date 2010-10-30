Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0J3Vkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:40:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61454 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0J3Vkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:40:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: nfsd changes for 2.6.37
Date: Sat, 30 Oct 2010 23:40:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101026164549.GD19445@fieldses.org> <20101027145929.GA5788@infradead.org> <20101030212500.GE480@fieldses.org>
In-Reply-To: <20101030212500.GE480@fieldses.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010302340.48311.arnd@arndb.de>
X-Provags-ID: V02:K0:DIlbeF5oOtVkAcJNVmAmdHRu3CsH8bKxi4REZDOhmdI
 G1Mb06tIkYeCz+q4LttBQhgpysKdEcuGgT5yweB2ltGWPGV5TV
 8GQQcni49E4tT87xMKTCcmxbsXPxMFZzjO11ak/+CGp8nDPZQR
 Y+/waYfhymogy7I2ptPefCDSz9Ei2yo01cSIKBlQCJZ/J6bKyd
 rZoDwbPrsFSdc3Cqsg1aA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 October 2010, J. Bruce Fields wrote:
> We still need to do this part.  I just did the minimum required to fix
> the problem--I figure splitting out a separate ->delete_lease method
> (which I agree would be cleaner) could wait till the next merge window.
> 
> Patches follow, tested on top of the merge of Arnd's patches; if they
> look OK they can go in, or I can commit them on top of a few pending
> nfsd fixes and send another pull request.

All four patches look good AFAICT.

Thanks for the follow-up!

	Arnd
