Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab0JFUcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:32:47 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:26009 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756643Ab0JFUcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:32:46 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: qN2rHpoVM1lDyKXaS1.A3TCx07hVtXw6Jrt3DHf4UORN1UZ
 p73h0abhRepeVjJSJzwpha5_H3_sApf3_pJ1udZQO0l9m5IXnk2O2.h_WhcA
 w_uIpUXrNVTHtJ_4Xj5hbjGOMvcwvEahUxx9VyHnMrXBGm8d0lRfZnzNZ7f2
 xfyG1b.DF_6jJiikvRL9ypoqrud9PyUHHUZHujXdK8DIAxOKjhlR3fTxu.y8
 J.rzq4JvgQWJqP.dayR8biUfap_fYRZSqFEb.9KH0Sg--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Oct 2010 15:32:43 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ben Greear <greearb@candelatech.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] slub:  Enable backtrace for create/delete points.
In-Reply-To: <1286395723-28271-1-git-send-email-greearb@candelatech.com>
Message-ID: <alpine.DEB.2.00.1010061527560.6878@router.home>
References: <1286395723-28271-1-git-send-email-greearb@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, greearb@candelatech.com wrote:

> This patch attempts to grab a backtrace for the creation
> and deletion points of the slub object.  When a fault is
> detected, we can then get a better idea of where the item
> was deleted.

We have had patches like that for SLAB in the past. The backtrace was
typically limited to 4 entries I believe.
