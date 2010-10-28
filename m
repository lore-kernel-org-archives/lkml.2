Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349Ab0J1Nry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:47:54 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43410 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933274Ab0J1Nrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:47:52 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1CVkttEVM1ngroHls6YmmLpEKnyiZrGSLLFnIEKBEXCEJZq
 xC6Kkmx4qEvWN8Uio2hq8G4VTq0xxx.fbbyOT9cKOquRA_ig45_0oT9yMbVq
 A3g3HrQf2uaAhAgzUw9d_ok2zSZc0vQPlsJRKZY2AN5RVMVEY3rHupZsA3LO
 9jDGQPd87moHHKnicOVmnAnaIu1Cc_GKSwkageZCt7vn2ggJsOyXBRZfGudN
 VXg0dtNDcC90XUY2lW.W6f2P_44M-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 28 Oct 2010 08:47:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dragoslav Zaric <zaricdragoslav@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Tickles scheduler
In-Reply-To: <AANLkTimOx=cMr+cwzEc8z7puZDEpa_7aDOxCPSzotjBP@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1010280845320.25874@router.home>
References: <AANLkTimzEDtfUKajFPgGOhifPhyRQboZbKNbypBaKpKO@mail.gmail.com> <alpine.DEB.2.00.1010260959250.10975@odin.tweek.dk> <alpine.DEB.2.00.1010271725260.9704@router.home> <AANLkTimOx=cMr+cwzEc8z7puZDEpa_7aDOxCPSzotjBP@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current plan is to switch off the tick when a process is running that
cannot be preempted ("realtime" (very bad choice of terms) tasks).

