Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1HTQBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 12:01:12 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:40891 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753452Ab1HTQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 12:01:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9xPQ6C8VM1lfS5RZ8A0R2MNo2JSAoeCECUVyt7etnqJcCtY
 RufD9lXoyJMeBdM1.fLnvwl.hQOE65ZcgFuvppbqpftwFFoCKkkS7_nW7fDb
 nMaT1kb5wN5tmZkGkLGytlDBHB7FbGVfhPUGJmgcBG9ANYioAmvZp0Fab2mr
 QQYdNouzF_EnHvcG8XwOdQcTCZlT_rBEC0YAPlHhZQQf8tkUeKF1NZ4CLBsT
 VdNkBh6uImUA7hjLqjqUvMYxWL1O04lsN3W8OXmV3V1tC7vGBGPgZ15srL5g
 uMBZjjJPU0wVe5TNmOepWJpjtkPcww1LLd_VbZdGxiL4E0WwtIxqaKFdtGbK
 aOc4KHbKeVndcsTY4xAro5pYIDPOVu.Y5S6bSgnqLHEMfGZ8_lSCIUzItyyA
 4ewrh4h_NYooQkoeLLP89FmEZro1GgSVY_m8-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Sat, 20 Aug 2011 11:01:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rientjes@google.com
Subject: Re: [slub p4 2/7] slub: Remove useless statements in __slab_alloc
In-Reply-To: <alpine.DEB.2.00.1108201340270.3008@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1108201100440.5267@router.home>
References: <20110809211221.831975979@linux.com> <20110809211259.776343341@linux.com> <alpine.DEB.2.00.1108201340270.3008@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Aug 2011, Pekka Enberg wrote:

> > Cc: torvalds@linux-foundation.org
> > Signed-off-by: Christoph Lameter <cl@linux.com>
>
> Linus wasn't actually on the CC of the email.

Quilt usually does that automatically when it finds a cc.

