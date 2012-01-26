Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab2AZPNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:13:24 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:29535 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751318Ab2AZPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:13:22 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WsjrE2MVM1nSuaNZHnpqIL3dPu9j8y25P761MQJxbHvrDAw
 kzfzHwb2EHZMaU2IKH6CRD2Z4jSwDZyYUg8pIj3jlrzTnrsyvid08r.6J3bj
 eiVXJhIDQ7HlBKKgN_FRcD8xWKEQ0Ajev_IC7WTmkB1OaJ6JV3zMgPmHq29Z
 NI57vNk82SzrM13p8mRpraHPBcuQ.Q4J.0rgfDoGHWIDOs1JAioPenpyiUzS
 82wDTXajYcYb.LeDUKzXflwAuIazfwxkmzttouhnWFmyMUtRMWyMjjKqzs8K
 gRl06snSuLB78rLOu0tnYk8_0fb_8.tFfXjG9P.NRs2l5ERhOfUYpYfwUuTu
 GkbMb5Kl9Tk5DaaJhN.A8VJdEutBF7h2zdLYX9PW6Nf.v_Y0Pe1Vx3xN9cYs
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 26 Jan 2012 09:13:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>, Milton Miller <miltonm@bga.com>
Subject: Re: [v7 7/8] mm: only IPI CPUs to drain local pages if they exist
In-Reply-To: <1327572121-13673-8-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1201260912540.23426@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327572121-13673-8-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012, Gilad Ben-Yossef wrote:

> Calculate a cpumask of CPUs with per-cpu pages in any zone
> and only send an IPI requesting CPUs to drain these pages
> to the buddy allocator if they actually have pages when
> asked to flush.

Acked-by: Christoph Lameter <cl@linux.com>

