Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0LASLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:11:40 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:29326 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752672Ab0LASLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:11:39 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CQuLHB0VM1mN__2zkyVFVTZkuOm1hOs5CfdSCGbYDkXDKvT
 6ia4t6Nh5NnE0Ki2O0kodIx8K2F.K7vig.e0laeXZ457Vo4NJaw.K7XK4A49
 02KVy.5elPWC3KzaLcgJ9bAUNWW6wekCYrzr595YQ43PYotUjr.rm31COrfv
 WY6lXqwCMsC2E2Gs6k.OuVfaylxXCzZXBUJa7Qdy8RXm8r8BGJk5Xeb5quoW
 FUP9GEcYWuevugiLFH2QA4CDh.CPSPDXm59jEmukRV_3lX1ZUsQY-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Dec 2010 12:11:35 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tero Roponen <tero.roponen@gmail.com>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] slub: Fix a crash during slabinfo -v
In-Reply-To: <alpine.LFD.2.02.1012012002440.1633@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1012011210190.3774@router.home>
References: <alpine.LFD.2.02.1012012002440.1633@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Tero Roponen wrote:

> This patch fixes the problem by converting the two missed instances.

Hmmm...A hunk was dropped somewhere.

Acked-by: Christoph Lameter <cl@linux.com>

