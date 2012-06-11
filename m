Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2FKFy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:54:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44307 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FKFyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:54:25 -0400
X-AuditID: 9c930197-b7b5dae000004b23-ee-4fd5880e5082
Message-ID: <4FD5880E.6070206@kernel.org>
Date: Mon, 11 Jun 2012 14:54:22 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Sasha Levin <levinsasha928@gmail.com>
CC: dan.magenheimer@oracle.com, konrad.wilk@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/10] mm: frontswap: remove unnecessary check during
 initialization
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com> <1339325468-30614-8-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1339325468-30614-8-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 07:51 PM, Sasha Levin wrote:

> The check whether frontswap is enabled or not is done in the API functions in
> the frontswap header, before they are passed to the internal
> double-underscored frontswap functions.
> 
> Remove the check from __frontswap_init for consistency.

>

> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
