Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1CJPfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:35:40 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:43125 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752210Ab1CJPfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:35:38 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: nAur_HgVM1nTTygR7hPOx7SBODjHDPZtAkTXPw9THQ9bztV
 2fmvMKNbsGYla_WkKO2WpBKOwMMHuZ2DuwvYIsyX3evA6Ox0BOaOEgM4kUtm
 YSW.z2sVcPMvu2HfZZ4wuqUwUELh2irwXpaYkxXGlbHKteP9LU1lOhawc2bi
 7IoCw.NsITPZZPIoIi1IO4rHUYkBfUN0qe3IzPYT.8J7iVFdY_DVpefHlN0s
 ibw6z_Tl4DrHqq56aXOLyAW07.GPb9VWIr48aeljiv3r_ealpbDCU9ralbzN
 IyjNxGkH31Dh8be4X3QFiXfgWpt1bCaxjJpGMtisreuRheKwstV8-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 10 Mar 2011 09:35:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3 V2] slub: automatically reserve bytes at the end of
 slab
In-Reply-To: <4D787C0C.7040707@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1103100935150.30899@router.home>
References: <4D6CA843.3090103@cn.fujitsu.com> <4D787C0C.7040707@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux.com>

