Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab0LUKjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:39:55 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:52409 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab0LUKjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:39:54 -0500
Date: Tue, 21 Dec 2010 11:39:48 +0100
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Message-ID: <20101221103948.GC14097@excalibur.local>
References: <1292924526-10850-1-git-send-email-stefan@datenfreihafen.org>
 <4D107CF0.5090007@kernel.dk>
 <20101221103101.GB14097@excalibur.local>
 <4D108249.4080205@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D108249.4080205@kernel.dk>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Subject: Re: [PATCH] block/cciss: Close continue statement with semicolon
 to fix build
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Tue, 2010-12-21 at 11:32, Jens Axboe wrote:
> On 2010-12-21 11:31, Stefan Schmidt wrote:
> 
> Latest head is:
> 
> commit e5fcdb7ed856b714c878ad470040fe832cbe462b
> Merge: 7bddaac 093d804
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> 
> And the fix is commit 453434cf3fdcd3954bb52460e37d4945a0913d3e. Perhaps
> the mirror is slow, dunno, I pull via ssh from master.

The mirroring seems to be the problem then. Public tree is behind and thats why
it is not fixed for me. Just ignore the patch then. :)

regards
Stefan Schmidt
