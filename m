Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637Ab1D1PZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:25:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33346 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1D1PZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:25:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH] powerpc: convert old cpumask API into new one
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <BANLkTi=EvC6E_p+XSpzZUvhu0Q_gStROcQ@mail.gmail.com>
References: <20110429000901.3D66.A69D9226@jp.fujitsu.com> <BANLkTi=EvC6E_p+XSpzZUvhu0Q_gStROcQ@mail.gmail.com>
Message-Id: <20110429002723.3D74.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 29 Apr 2011 00:25:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -268,9 +269,9 @@ void __init cbe_regs_init(void)
> >                                thread->regs = map;
> >                                thread->cbe_id = cbe_id;
> >                                map->be_node = thread->be_node;
> > -                               cpu_set(i, cbe_local_mask[cbe_id]);
> > +                               cpumask_set_cpu(i, &cbe_local_mask[cbe_id]);
> >                                if(thread->thread_id == 0)
> while you are here, could you add a space between if and ( ?


Oh, this is NOT a part of my change. I don't want to insert unrelated
cleanup.




