Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0ETRMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:12:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab0ETRMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:12:31 -0400
Date: Thu, 20 May 2010 19:12:30 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: RFC: dirty_ratio back to 40%
Message-ID: <20100520171230.GA6910@fancy-poultry.org>
References: <4BF51B0A.1050901@redhat.com>
 <20100520122919.GA3420@fancy-poultry.org>
 <4BF53D8B.5090407@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF53D8B.5090407@rsk.demon.co.uk>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100519 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX18hfAXogarWmw9onmGY+5Vo4+QIrxnahAmIrB8
 J5sh9RifFfbSWUzDlbEpTbu54Zjawwv6A8gO98SUtTcH65zQBV
 1PoGQe6PpFrJ/M0gFCMnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.2010, Richard Kennedy wrote: 

> But it's interesting that you find lowering the dirty_ratio helpful. Do
> you have any benchmark results you can share?

No, unfortunately not. My machine is mainly designed to run squid,
and it suffered from very long stalls. After posting the problem, I was
advised to read about vm.dirty_ratio and vm.dirty_background_ratio, and
lower these. I tried several combinations, and with 4/2, the stalls
vanished completely.

