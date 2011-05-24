Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1EXOIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:08:51 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:48593 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932213Ab1EXOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:08:50 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _93I2g0VM1nBvYJTeydZheQliA4H1WBXUBJqIPslKOCwnrJ
 mPcbuztf1RA2JJvRoncHF3SBhcceWcXMFTiZwOSTEKdvC2WBzDkh_SU1Kz7B
 1g6IYUX6LsTPD95_vKwiAZWh3g839KWN5NDnxQDWFvEJ.1CoGrKA75abct0o
 7BP7AWAhfB5VO2IlnekuFFaQtY77Z4B84LawQzDrQoqSNJMWCyxNvhrXMax7
 bnHEGCJ0CL3C0k_7Hionuoao_d9WlvS4tBWSCU6YfCfZoD2HkR_LKHoepmQy
 LBtQ0IevGnuxA2QGfQPoyIBlWLvzT0q8uBbdPq7Zg8_b196JF
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 24 May 2011 09:08:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Morris <jmorris@namei.org>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: SLUB regression in current Linus
In-Reply-To: <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org>
Message-ID: <alpine.DEB.2.00.1105240908100.25760@router.home>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org> <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, James Morris wrote:

> On Tue, 24 May 2011, James Morris wrote:
>
> > Reverting the patch appears to fix the hang for me, although I'm not sure
> > what the actual problem is.
>
> Disabling slub debugging also fixes it.

Boots fine here with and without debugging. Could you send me the kernel
configuration file?

