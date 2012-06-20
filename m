Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2FTCxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:53:44 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47492 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2FTCxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:53:43 -0400
Message-ID: <4FE13B2F.4080701@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 10:53:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 10/10] cleanup the code between tmem_obj_init and tmem_obj_find
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE03A55.7070503@linux.vnet.ibm.com> <4FE0AD89.6000001@linux.vnet.ibm.com>
In-Reply-To: <4FE0AD89.6000001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062002-9574-0000-0000-0000033B3FB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 12:49 AM, Seth Jennings wrote:

> This patch causes a crash, details below.


Sorry, i forgot to commit the new changes to my local git tree, and
posted a old patch to the mail list. :(

