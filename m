Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920Ab1KAFIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 01:08:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42619 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750702Ab1KAFIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 01:08:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX195p4EPFhZ5i6YW5iFJ+c5EimNf6oJ2jWhYhKR4wn
	dOglUoFcvdhdaa
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <con@kolivas.org>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org
In-Reply-To: <2516934.OmMpfqGngS@quad>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
	 <1479015.f2tEjKr9vR@quad> <1320061348.6389.18.camel@marge.simson.net>
	 <2516934.OmMpfqGngS@quad>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 06:08:09 +0100
Message-ID: <1320124089.6305.65.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 11:41 +1100, Con Kolivas wrote:

> Fortunately BFS is about optimising user visible service latency for normal 
> users running normal applications on normal desktops under normal workloads, 
> and not about tbench throughput.

Unfortunately, cache misses are an equal opportunity pain provider.

	-Mike

