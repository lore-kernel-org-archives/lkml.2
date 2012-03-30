Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934710Ab2C3UtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:49:17 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:30613 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933072Ab2C3UtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:49:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WpcZLDwVM1lMxJcsIguE1aYgJOW_6AZwX2VAIwT0wMWkkOF
 huaEXoWfTIDDfcsDr0I_kg0bnbRnk.juHUQTt7uwq3c5nYImI4ijMY3KrB4c
 MKQ4.LKBVKz.7UrprhRnqFf6Ts7EMnv0Cci.A5ZdD_cvuGWxKll7z4_6lkaT
 bQaXBQ7g7fBG._.qrCj7r_kP2hmkpjWO.0S98uzhckNkkX2HmatcZVWSmRL8
 IMD4H7Suak3LnNst9actaAHNKmb.ftKL0Xyu9tkj7bR6SQfpH04J1iUy10.N
 4_qdxJ8n2T9qAXfqoJC5DsOt7ynfiJ76YCJgBYKq0LVvV4A2aj6PFicTSG.i
 u7kskitohXfj2yKIC3oBi3jYhGMh9zr4kRCqFWavWxTeHHoWohzXVcSq1Hrn
 o3IzpCPp5PMiowP2WKVmRjLvtehYpjad6D3TL
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 30 Mar 2012 15:49:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Larry Woodman <lwoodman@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
In-Reply-To: <4F75EDC3.7050104@redhat.com>
Message-ID: <alpine.DEB.2.00.1203301548070.27435@router.home>
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com> <alpine.DEB.2.00.1203221421570.25011@router.home> <4F74A344.7070805@redhat.com> <4F74BB67.30703@gmail.com>
 <alpine.DEB.2.00.1203301113530.22502@router.home> <4F75EDC3.7050104@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Larry Woodman wrote:

> of nodes.
> >   I would think that the 1-1 movement
> > is only useful to do if the number of nodes in both the destination and
> > the source is the same.
> Agreed, thats exactly what this patch does.  are you OK with this change
> then???

Please add to the patch description some explanation how this patch
changes the way page migration does things.

