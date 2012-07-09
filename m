Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2GINxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:53:17 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34848 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753521Ab2GINxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:53:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Q0YinNgVM1ndl1UzGZ2Jw6wLqovh1JHsaj.5KPy6sZ0Eu_T
 jHkO7lyg1uQY.OoZZeGN66Bp.VwzXKcNO8xoxL.BlALRhZtHrt7_m1v9FgwX
 SmJNsY7VegcL7m94AYQCb05vPiWPHR2TuOsh.MhqaH1PmdVoYEvHc2anDfOb
 h4ANWInMcrkCyvDPzBpOBKLwkwZd0_yNCm4crL9wYv4mpgsOky6jAEI.z.Qq
 j2XKn7Pcl2NHIVLipPL4U6E_wT0aTuNCvyBqTtQn9fL7y8vSofacRm1I79gB
 gQVJai_QluS06BJxp9v6nRYAy9sRiWgsXWylzKuCPmdeidc_lqOoyV6IreDe
 rF9H1oi7ka9P1O0XRJ2.1auVs4MQ7SnchBMA.S54UJZbvPtDolcIUL5.bEK7
 I
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 9 Jul 2012 08:53:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Julia Lawall <Julia.Lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] mm/slub.c: remove invalid reference to list iterator
 variable
In-Reply-To: <1341747464-1772-4-git-send-email-Julia.Lawall@lip6.fr>
Message-ID: <alpine.DEB.2.00.1207090853010.27519@router.home>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr> <1341747464-1772-4-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2012, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> If list_for_each_entry, etc complete a traversal of the list, the iterator
> variable ends up pointing to an address at an offset from the list head,
> and not a meaningful structure.  Thus this value should not be used after
> the end of the iterator.  The patch replaces s->name by al->name, which is
> referenced nearby.

Acked-by: Christoph Lameter <cl@linux.com>
