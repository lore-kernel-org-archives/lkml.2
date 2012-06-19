Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2FSQff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:35:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39254 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2FSQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:35:34 -0400
Message-ID: <4FE0AA3A.8030805@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 11:35:06 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 05/10] zcache: mark zbud_init/zcache_comp_init as __init
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE039BE.6010406@linux.vnet.ibm.com>
In-Reply-To: <4FE039BE.6010406@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061916-5518-0000-0000-0000054EE363
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 03:35 AM, Xiao Guangrong wrote:

> These functions are called only when system is initializing, so mark __init
> for them to free memory
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>


For patches 05-09:

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

--
Seth

