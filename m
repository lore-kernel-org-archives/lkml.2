Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab1GTPfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:35:04 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:23792 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751619Ab1GTPfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:35:02 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: asCiFUYVM1mB8jkGqP.EytoWPN8OLV7GIo8Or5mWy1vvw05
 YrMwIdSYOefMNAUwAKxOMh_jLf3WFaLIUWPee9mUGfGoOLuHsItoVVgjnLmh
 72AKUhhSSexR_Gv4NJBYVZcBoV7IQqt4ypCzbJ7yJ1ZmYtRwICSG_8KsRH6A
 0VlxQm3fwjUYB217aISntyI32RfNl_6DsnTN59Bt_PAXXZbynrRollQ176QC
 te2AwkV8px19RoQi4t4XcifNn55z8RZj8RdeYNUblOjJVcOwcUZVTeINxqxd
 U2JUvatmBxD9AUsQqX32xtoO.BKV6crp2Omp52H87SwJpbDHQ_ftI
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 10:34:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1107201033080.1472@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>  <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>  <alpine.DEB.2.00.1107200854390.32737@router.home>  <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> 
 <alpine.DEB.2.00.1107200950270.1472@router.home> <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Eric Dumazet wrote:

> [PATCH] slab: remove one NR_CPUS dependency

Ok simple enough.

Acked-by: Christoph Lameter <cl@linux.com>

