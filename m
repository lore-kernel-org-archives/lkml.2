Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2EUQXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:23:10 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:25922 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752628Ab2EUQXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:23:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EGai_v0VM1nBhcyxbqJhTQ.lVZ6DIflSoLVpKOifHbuDU2m
 R7KT3C3E56OFjDunqc8W83s0qXB6n_sHgSH3wbm.DGXkymDo7lEnpHT_3gif
 bF7FJ6cPCFZ6zICCtzOLlTFVTdh_wlBlpswnDHIO.hACvf0NeuOYdS9eruMM
 RnRMDz0TUezHlux1V2j.g0QZ44BcQtShBFMlniP92SEMm37Q9GF398jVgpJE
 NlMq35rcVKD5HuQgRtofeg74fbcUwZu3rPUha4dkqx4yrFtuOaGAZR4WZb1x
 aK6hBa144hs3cQfOrU.Mqi6TDvURX.5YVcK0replbTp7DUvvmrydYIAaoMZf
 fh9beHZXdynN2oHBHZ1YW.vshg6vxzE8uuaF7myLEuU404OmZ4tas4fc7s7t
 5SRFE0osZP6L94RE6BwhEabBldnzc.dVe2lGnSGjS
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 21 May 2012 11:23:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, aarcange@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, hughd@google.com, rientjes@google.com,
        adobriyan@gmail.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] hugetlb: fix resv_map leak in error path
In-Reply-To: <20120521142822.GF28631@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1205211122360.30649@router.home>
References: <20120518184630.FF3307BD@kernel> <20120521142822.GF28631@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Mel Gorman wrote:

> > Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
>
> Acked-by: Mel Gorman <mel@csn.ul.ie>

Reported/tested-by: Christoph Lameter <cl@linux.com>
