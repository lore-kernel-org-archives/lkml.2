Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0KSQKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:10:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39114 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753925Ab0KSQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:10:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/r1t1HSHDrsiIP7nwK9fF/A/4aWpGshULcMl9jJB
	zil5KQB76NVAfh
Subject: Re: Galbraith patch
From: Mike Galbraith <efault@gmx.de>
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: Gene Heskett <gene.heskett@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201011191509.49586.jordipujolp@gmail.com>
References: <201011191509.49586.jordipujolp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 09:09:58 -0700
Message-ID: <1290182998.24581.8.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 15:09 +0100, Jordi Pujol wrote:
> Hello,
> 
> it requires a little modification,
> 
> CONFIG_SCHED_DEBUG should not be a condition to create autogroup in structure
> task_group

Yeah, thanks.  It was initially a debug only thing, but evolution
changed that.

	-Mike

