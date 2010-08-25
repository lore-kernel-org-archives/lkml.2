Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0HYTL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:11:29 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:33689 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752007Ab0HYTL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:11:28 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Io6OY0YVM1komF2eB5r6r.qIVGS0s.OOsGNcWpyxqr04Ozs
 du0xy1GZIC70zJmQIYfFBXCNrpX22fArhwO3HT_julyjTLAP7YYGt4LQ6sCo
 s6xSWbYWiJcut01B7cSVADbVPsPN80Wk1DjDlMwi9o136KMuKoxev1hmljSA
 rUAI5gb5DqV9s65HcZPVM0t2K6kNKM6SRnNKTLkXVFtlzyQ3aKpqLF3En_tg
 qcxMcaBpYtpjh2VFe4EjGHeSmZYM-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 Aug 2010 14:11:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for August 25 (mm/slub)
In-Reply-To: <20100825094559.bc652afe.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.2.00.1008251409260.22117@router.home>
References: <20100825132057.c8416bef.sfr@canb.auug.org.au> <20100825094559.bc652afe.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Randy Dunlap wrote:

> and in different builds:
>
> mm/slub.c:1898: note: expected 'struct kmem_cache *' but argument is of type 'struct kmem_cache **'
> mm/slub.c:1756: note: expected 'struct kmem_cache *' but argument is of type 'struct kmem_cache **'

Hmmm... Any details on the configuration that got you this result?


