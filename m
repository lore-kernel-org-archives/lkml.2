Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab1EIJF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:05:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50505 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1EIJF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:05:27 -0400
Date: Mon, 9 May 2011 11:05:55 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: AMD C1E issue?   2.6.38.4
Message-ID: <20110509090555.GA9184@fancy-poultry.org>
References: <4DC54CE5.6050307@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC54CE5.6050307@xs4all.nl>
Organization: private site
X-OpenPGP-KeyID: 0xE9002778
X-OpenPGP-Fingerprint: C661 CE20 7105 B0DB 49B5  CDB2 298C 801B E900 2778
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+22 (8d0281f79b21) (2010-12-30) (GNU/Linux)
X-Provags-ID: V02:K0:nTIdXpDPtXZ4yK+m44r+9AJ7XgrojkTy0dZ5QvlebYZ
 SCMKBeLF44eShogLPsQqjIds8WUtzZ6CHTJOCaphxSCEIUsGt1
 kZC6beN+v/NH07bFEq47vhcy2u4dn1jQHgxGSuswx35dBzX2h2
 pB4LQqRwQSEosZR2btWhoBMV0A3Ft95Ykmx7HnQ8bw+R7Dgmow
 MVayGiakXyKJK4z20sq6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.2011, Udo van den Heuvel wrote: 

> Anybody can tell why the update cannot work?
> The previous board (JNC81) did not show these but also did not have C1E
> in BIOS as far as I recall.

If you have C1E problems besides of the microcode thing, which isn't
related, you could try to boot with acpi_skip_timer_override. That
works in my case.

