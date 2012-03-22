Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030564Ab2CVTlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:41:12 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:26301 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755562Ab2CVTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:41:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Qg9CBcoVM1mpNN7MfWO3DFbiyXsPIHTPFJYaZBz9UIVV5vd
 b2kJrfNiBLMBrNIyvXPqwB1Cy1Fezf2rFSs0_iBoNHTFZYMm4EjBBdtukzHR
 HmeOXFSOX3VK5PSn2NHv440hEkqIjSttUrjYD98x60yuBs1dIEACBnUfCeas
 xuRpDDO84.DFx773G74RkB9..aEjARWEy4GbkduxuQy0AyEe3s3Lw0.DGSpX
 0jMw9SIIv4i2OxNxGh0xLMWNmI7u76VXBZvNQVfILzA1U4ZnL794M.z408Ag
 8zC7ZoUkIghF6hXsb4gCn.wO1HjSQv7Y8SLW0YxSGJaLLmasOI_.AcRzQlSo
 1s5xbSMH7JqbZkl1vngNb4c5SVd65JjoHXnmLA0pus1NxiXoXffb9VxONg1H
 TA3CbO8jHHZ3xyWMFT3fpFJMCBwzvTbfrBlwJ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Mar 2012 14:41:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Valdis.Kletnieks@vt.edu
cc: lwoodman@redhat.com, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
In-Reply-To: <40300.1332445016@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.2.00.1203221440380.25011@router.home>
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com> <40300.1332445016@turing-police.cc.vt.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Valdis.Kletnieks@vt.edu wrote:

> > So to be clear on this, in that case the intention would be move 3 to 4,
> > 4 to 5 and 5 to 6
> > to keep the node ordering the same?
>
> Would it make more sense to do 5->6, 4->5, 3->4?  If we move stuff
> from 3 to 4 before clearing the old 4 stuff out, it might get crowded?

Right. I thought Paul did take care of that way back when it was written?


