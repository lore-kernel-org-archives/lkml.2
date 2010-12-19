Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0LSNy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 08:54:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab0LSNyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 08:54:55 -0500
Date: Sun, 19 Dec 2010 14:54:49 +0100
From: Heinz Diehl <htd@fritha.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #19632] 2.6.36-rc6: modprobe Not tainted warning
Message-ID: <20101219135449.GA13734@fritha.org>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
 <xqq2Z3iR9HJ.A.1bH.l2fDNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xqq2Z3iR9HJ.A.1bH.l2fDNB@chimera>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:gDNsvar3bNTCILCqtaTIMyUcCGfy7thXpy7/rrk1OeM
 Kne+Uo5un51GohU70VuKiic0kpmTQAXsIfBkEuxLCikTyI2g/x
 gAsJ+ZGKSOKjFyPa2eHF38/FqFBoC87+VHfUvEF+0e6BaODBTS
 r4yGTXiJzO+az104vxpPptrnumQKLhSuR4HvWZNioi3ZtVB6H2
 Ueoc1FhYpjqUcG5BwzhoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.12.2010, Rafael J. Wysocki wrote: 

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.35 and 2.6.36.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19632
> Subject		: 2.6.36-rc6: modprobe Not tainted warning
> Submitter	: Heinz Diehl <htd@fritha.org>
> Date		: 2010-09-30 18:25 (81 days old)
> Message-ID	: <20100930182516.GA15089@fritha.org>
> References	: http://marc.info/?l=linux-kernel&m=128587114004680&w=2

There's a fix pending which should have made it into 2.6.37:
https://patchwork.kernel.org/patch/240661/

At least, it fixes the problem for me.



