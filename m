Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab2EVRQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:16:23 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:28570 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752225Ab2EVRQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:16:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wkv_y64VM1nZqnN_0whZ9XPqhPOhIBnrqq2fzqM2cvzZL__
 Oq3tDtgTO5HI6869YJVCjOrc0RLIapSShObDO3TlQDUT4qFl2991eDt.HwaH
 WwiXIaP8DDnbFW.GUb10BH52oVQXyuFS8TO3yjmjJvYhg2AcmxNeJiwrvJzN
 Bbgcb_o_kvOvYSpPbu960YXkFzLfwaI8hhOJB8XJ6YXpbwUdgLqSl2OsH9g.
 rvPJToQrOrEkIw7EvFYcXFI_2e1svi_LzG7of7U11bjyINdG3g8mNrgOEO_5
 TJPPvxWVMA6afQl.cxon8s4HrSLhEddSRQ3u5sKBOW_bmQp7S5iMmc6D5E1v
 CEboqwANkHi6VEH.g6YJl6ExCcytn20Uhk42J2jAR3tJ1JTizgDd7h8NfsA6
 QlOlv
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 May 2012 12:16:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
In-Reply-To: <4FBBAE95.6080608@parallels.com>
Message-ID: <alpine.DEB.2.00.1205221216050.17721@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Glauber Costa wrote:

> I think that's precisely David's point: that we might want to destroy them
> eventually.

Cannot imagine why.

