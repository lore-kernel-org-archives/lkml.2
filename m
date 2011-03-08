Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1CHSYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:24:16 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:35215 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753405Ab1CHSYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:24:12 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: tsDnOgUVM1mQvTd33QAtsIapiDPIjwd1egoZu4rA95ZA_Nl
 T0fT2CotDi9Uu.1Vn0Zg9tSSTUiAcydhISuLAHQAz19H8rXM7c3O3_z4dMfK
 yswivQXKXL6IhCtACDBCFXB_4JotNF3L5t0Luh3fl_KgtPjYjfsYHBt84FLe
 q2xXo6Vnqef5AItKAzhfSUEfC6pdCYUsrsF2qV1Cu5MUsSjwi0uPJ1R5FH6Y
 A74ib9XhrAojW2EkVzdxraIWeUx3CvHpSX.h5f8PEK_bUfULnYV2LlsHO.O8
 FZTLO4_rY0MKDYeQJqbZyu2.siL4wCwPejBtQVY0JkepdEMg-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 8 Mar 2011 12:24:07 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] slub: automatically reserve bytes at the end of
 slab
In-Reply-To: <4D6CA84B.9080606@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1103081222380.25214@router.home>
References: <4D6CA84B.9080606@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Lai Jiangshan wrote:

> So we add a field "reserved" to struct kmem_cache, when a slab
> is allocated, kmem_cache->reserved bytes are automatically reserved
> at the end of the slab for slab's metadata.

The reserved field should be exported via sysfs. Please add the code to
show it in /sys/kernel/slab/<name>

