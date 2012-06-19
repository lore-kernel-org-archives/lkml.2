Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2FSOhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:37:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41553 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2FSOhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:37:41 -0400
Message-ID: <4FE08E8B.6060000@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 09:36:59 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 04/10] zcache: remove unnecessary check of config option
 dependence
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE039A6.4050206@linux.vnet.ibm.com>
In-Reply-To: <4FE039A6.4050206@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061914-9360-0000-0000-0000077F7C17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 03:34 AM, Xiao Guangrong wrote:

> zcache is enabled only if one of CONFIG_CLEANCACHE and CONFIG_FRONTSWAP is
> enabled, see the Kconfig:
> 	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
> So, we can remove the check in the source code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>


Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

--
Seth

