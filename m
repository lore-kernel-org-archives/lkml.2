Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2FKFwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:52:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64817 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2FKFwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:52:12 -0400
X-AuditID: 9c930197-b7b5dae000004b23-2e-4fd5878a7c10
Message-ID: <4FD5878A.7040103@kernel.org>
Date: Mon, 11 Jun 2012 14:52:10 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Sasha Levin <levinsasha928@gmail.com>
CC: dan.magenheimer@oracle.com, konrad.wilk@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/10] mm: frontswap: make all branches of if statement
 in put page consistent
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com> <1339325468-30614-7-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1339325468-30614-7-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 07:51 PM, Sasha Levin wrote:

> Currently it has a complex structure where different things are compared
> at each branch. Simplify that and make both branches look similar.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Reviewed-by: Minchan Kim <minchan@kerne.org>

-- 
Kind regards,
Minchan Kim
