Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1LND23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:28:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33875 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab1LND22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:28:28 -0500
Date: Tue, 13 Dec 2011 19:28:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wang Sheng-Hui <shhuiw@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb.c: cleanup to use long vars instead of int
 in region_count
In-Reply-To: <4EE6F24B.7050204@gmail.com>
Message-ID: <alpine.DEB.2.00.1112131928110.3208@chino.kir.corp.google.com>
References: <4EE6F24B.7050204@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Wang Sheng-Hui wrote:

> args f & t and fields from & to of struct file_region are defined
> as long. Use long instead of int to type the temp vars.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
