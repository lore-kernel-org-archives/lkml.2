Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2HBQJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:09:41 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:36665 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752399Ab2HBQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:09:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2ibybb4VM1lDt6x0VBFgDjao4h_gCXofpTYheI7TNja5cUY
 hRyjyuI4f6jqXTxt35iB6zQFTzbm94n_dZiGqCX3flh.KE1pAzcgyJtubDrJ
 oF.ZLJo0EHWHP4X4wXoDtNKkfAyrfMnFy0wmD0nyoedQ49pTtCvCpSKbyHzS
 k3dGFdsKhjWXTXcdgmPxRY04U2iE8KWa5ykaOYFWp_CG8lNXD.hnbLzznNyT
 yNsrVQAKvJwOKdyXZ_TEYhj0I89DpNkbl860056tsUiqwmeNUzkhAUHGv1q6
 .mkbB0.FrJh7Q4AkqDF1neSF_B3IXREwpXD.gp_l59Z2aEuNLrD1eUF5CD3J
 ZngaAnu8nLVzqiF5V2geUFetrrc4HIJoQWqdkGAgKFxeGJHKVt2kzImXEQR8
 01AOBKJ48YQrkVda_10W0mw1RXTpG6SV8t141U1nVEHv0bjwQGQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 2 Aug 2012 11:09:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/23 V2] mm,migrate: use N_MEMORY instead
 N_HIGH_MEMORY
In-Reply-To: <1343887288-8866-6-git-send-email-laijs@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1208021109200.23049@router.home>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com> <1343887288-8866-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2012, Lai Jiangshan wrote:

> The code here need to handle with the nodes which have memory, we should
> use N_MEMORY instead.

Acked-by: Christoph Lameter <cl@linux.com>
