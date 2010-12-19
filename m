Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab0LSN7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 08:59:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab0LSN7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 08:59:31 -0500
Date: Sun, 19 Dec 2010 14:59:27 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Ketil Froyn <ketil@froyn.name>
Subject: Re: [Bug #22092] Kernel v2.6.36 trouble on USB disconnect
Message-ID: <20101219135927.GA14334@fancy-poultry.org>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
 <xqq2Z3iR9HJ.A.ObG.m1fDNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xqq2Z3iR9HJ.A.ObG.m1fDNB@chimera>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:MaUBF+EbdynnCH9eF+2X0OLELw8YtolUHfdigaM8El5
 UV9yLmXFeJkNHB/+1f4hfnpEdRVGa7dNesx3WhZsIq3JzUU74a
 fl4OzYTLvTaNa/ifvdv0f1C2cdsD+983UKEeTqF2vmkFToM0ME
 DW9yJKghTvCq9BhWXfb7X+ACMfRpUtNkc+7rCag28/e1L20y/u
 4PfkA5Q+oIivoOQHL9urA==
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22092
> Subject		: Kernel v2.6.36 trouble on USB disconnect
> Submitter	: Ketil Froyn <ketil@froyn.name>
> Date		: 2010-10-29 8:05 (52 days old)
> Message-ID	: <AANLkTik5qVxkEGVAA1PSOGk2KTW+ekHpSwttsQEWzWj+@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=128833956503607&w=2

I guess this may be a duplicate of this one:
http://bugzilla.kernel.org/show_bug.cgi?id=24722

