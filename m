Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1GGOyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:54:17 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:34305 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755644Ab1GGOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:54:13 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: RI4R6VAVM1lkJPtSU2vRBl4WkyypU17HoF0rznIw69gp1zg
 DlK7uWVajLlcyRCXLP4G_ghbUYkPXLohEsR40XxqoiK7f3nn6CUKCKRhMZVc
 mXmn992.8RZbV1qptwdlSqoDeewYr7hbsDC6KjeRWFcN5BtOtx0WbpXh9bHO
 KW9NDwKv6.6NkG.l._jYpJwlomPJWLqF8mR_OUxBlv5ikQ.M..UASELRMBIm
 X9XIYCrJHWyusk5CiwVzu01nuR83oam1rj98OSbuBNyfdiuJuazKfl.LgEOq
 0hVW3tGYULU5LBiHs2_kYE9_nq0DlJxeHnNS4LqCR9WCzVulwEiFr
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Jul 2011 09:54:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Piotr Hosowicz <piotr@hosowicz.com>
cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Build issue with linux next. duplicate member _count in
 mm_types.h
In-Reply-To: <4E15C59E.5000900@example.com>
Message-ID: <alpine.DEB.2.00.1107070953350.17929@router.home>
References: <4E143120.2020501@cam.ac.uk> <alpine.DEB.2.00.1107060933460.17202@router.home> <4E15AF1C.7080103@example.com> <alpine.DEB.2.00.1107070841500.17376@router.home> <4E15B945.5060805@example.com> <alpine.DEB.2.00.1107070908320.17929@router.home>
 <4E15C59E.5000900@example.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Piotr Hosowicz wrote:

> Mine is:
>
> aapi205:~# gcc --version
> gcc (Debian 4.6.0-10) 4.6.1 20110526 (prerelease)

Uhh... Guess its strict checks hit me there.

