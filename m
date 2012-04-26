Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab2DZOu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:50:28 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:48617 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757235Ab2DZOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:50:24 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Qgye8aAVM1lJY4dFaXAtlC_9L_0JouEyG4NWu3O7JDXXZXp
 f7Kvu2LslVZm4kQ9r8bsCQKh01kxmVUdzVaI3wk2E2kYQ7MGfq6PkYvmuCmy
 USwGYgODDrke4UNbDE9JTe1xDaj2djnLYNcB5e.OOVYnX2DZSqXyLDoiq6qY
 Yb5W88ZLbmFVwKnq.31TjKaqbc07ivjLhCT6kK8VvEP4Dbryd0wgTi20t8.a
 fm4nhAN_K3qH8roGawBLaSe_DAguZkbGKidngGytu8J45qQdMjKe4t0gXa0R
 P.xWv1K0rrWeU54mv3nm2gxWk.8O5qjfgA3YQsfqCJO.VoSsD5SXQ9TZWB8e
 QLir_YO.Mom9T3y6CGMqqr20FWe2rPGXZFX6UYx3v7uNWGIUffU1k43eTN8t
 x
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 26 Apr 2012 09:50:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Davies <richard@arachsys.com>
cc: Satoru Moriya <satoru.moriya@hds.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
In-Reply-To: <20120424082019.GA18395@alpha.arachsys.com>
Message-ID: <alpine.DEB.2.00.1204260948520.16059@router.home>
References: <20120424082019.GA18395@alpha.arachsys.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012, Richard Davies wrote:

> I strongly believe that Linux should have a way to turn off swapping unless
> absolutely necessary. This means that users like us can run with swap
> present for emergency use, rather than having to disable it because of the
> side effects.

Agree. And this ooperation mode should be the default behavior given that
swapping is a very slow and tedious process these days.

