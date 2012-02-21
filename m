Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2BUPxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:53:12 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:29968 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752134Ab2BUPxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:53:10 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Np3.S7gVM1lSE1rll096cV3ibE6DmzIsmq9n1ypJOQOMiDb
 JYdiLbO0JaYqWoXjO.tqVb1LyCH8jtcVhrqTXuILriK07_Vn8Ha25MQ3HGE0
 zKWIhgYa1YtKUHovNHbPTwYjtAnAJzCe3BhVi_UrQ6qjjx5hu.Bs3XQPn9sn
 aSFakSY3ErjXkOvTy3jsDvCnDA0ma_ey8gMrxWsKMlVq8TkYMe9yp2LL7l0.
 IIvk2OS2m0KXx3497oXuW9C802BcPZSpnABJ8z7lh1qVQy1ISgsIpjPXct_I
 DwSsyuWb4ykV_sHIWQn4TM5MUmBFZeiBLkes3.lQwJRaxVY4CnoIyMrY1n2q
 caVqCla9T9zFUIGdmozwO90wJ1U0t3GusJZ__UJzq1qZdXmiiTc5Ypaz3P_f
 0HheuFjL4bUQnsyJgZuatmyNMJcW1FktzGdw-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 21 Feb 2012 09:53:08 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix generic definition of
 __this_cpu_add_and_return()
In-Reply-To: <20120219142911.12300.7497.stgit@zurg>
Message-ID: <alpine.DEB.2.00.1202210952510.10145@router.home>
References: <20120219142911.12300.7497.stgit@zurg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Feb 2012, Konstantin Khlebnikov wrote:

> This patch adds missed "__" into function prefix.
> Otherwise on all archectures (except x86) it expands to irq/preemtion-safe
> variant: _this_cpu_generic_add_return(), which do extra irq-save/irq-restore.
> Optimal generic implementation is __this_cpu_generic_add_return().

Acked-by: Christoph Lameter <cl@linux.com>
