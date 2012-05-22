Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2EVN6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:58:13 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:24756 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752977Ab2EVN6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:58:12 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 23SZJlUVM1mp5.zHNJrFiuYHby0I8JTSkIud94895_UAez_
 bmGmKVR_hlnOw7NBD.zOcXzYv0ezTQE3Hun6PHxgej10tPO9h.TXo2IOcpcT
 HniMJu0lb2bujKdDfUK0eLQ5nNqZh47TnedWguih0Pma9oo7.FrF1yp2iHKY
 3UIIgqKtUqrjH917M2g1kKjHoftMV5id42iE0AMtQ12iv5b8UTdPxUtIvYj9
 K15M8iDHKDfNv_u6Npy0eqVvt8N1esngViiuALYA3PZwMXzPESmW.bkcSSWZ
 DWfC31u1tFJZ5Kz7PIAONcts3LFDoQ5Y_J2tii2EeyHQ.KwpIZvF55ALS1FM
 Mu.pRQD1iDZ8OpN0Q1Pgd5HEt8sTQ7iN4nVPTUZavmd1hJ_wolwOZ.pV3jyj
 sJ2yGfeXa9Bwm.4unGXyQ1QLz3zpJHanPjsk-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 May 2012 08:58:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2] slab+slob: dup name string
In-Reply-To: <1337680298-11929-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205220857380.17600@router.home>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Glauber Costa wrote:

> [ v2: Also dup string for early caches, requested by David Rientjes ]

kstrdups that early could cause additional issues. Its better to leave
things as they were.

