Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2HBQhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:37:54 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:44878 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753099Ab2HBQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:37:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cuUUVwEVM1ky9n8UQwHkjoslORC2.IRqRyg9RivE86bulkK
 _CjI3dDp4Dk3dA6Bu4aKQnMdLTsulz4G2oafeu2dVBY3qnO_qsIaS6Ax.kfF
 vSPkDtTj_SMrMRLSgPGCOjXXOhje3cfwE0FPEXWJXz.ajKDYCjIPwMlCZwep
 5spPzyo93yrQKGQI61WoK2zvn5VUWfYEoLSsmjqubGed4Ua_iOS5MxKbOHLX
 TiXnZpVSio5ZPGaN2dn6__rklIHJ9Ff8K65rz1gljlcfQFJ4_lcWdiuBtATX
 AClWCY4DGyfDuIt5zxjePx0WdV14nSnp.GSh.03AINGnAwNRzoTkZumkPglj
 HIVG5KgKArODFhRKWse2VEQBL0CsBOYqMrynLrmQKh.fuDf2IzsNRpQR02_n
 4ODdxZGu9.lyHWfQ4ougWlW8tZwH.GsLBBmgphJpY3dRQTmnDhA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 2 Aug 2012 11:09:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 09/23 V2] vmstat: use N_MEMORY instead
 N_HIGH_MEMORY
In-Reply-To: <1343887288-8866-10-git-send-email-laijs@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1208021108430.23049@router.home>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com> <1343887288-8866-10-git-send-email-laijs@cn.fujitsu.com>
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
