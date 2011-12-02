Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1LBOo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:44:27 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:43481 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756742Ab1LBOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:44:26 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5Sly_foVM1lKmlRygoP7HY7eULnPhQo2IVKjfqAIFAQBF7r
 DT_mOXhGDQkVaON5NLU6Sk5z0ddOMIEmTEqsGMWAUuuFbJPy.i0FM2uOJjdv
 xLAkPuog2x7luPlKA9KcilSsB9sXciksSS1tOdZPJEQOVWbR6HiCP8JzxoXD
 SmmpmvONwDUlninfWr_dRpcb8HfkNo31JSpRqLLVJU_MLYpwlSXyyzFhUV30
 dX4c9JsoXXOeqNdd.J7WuX4hFRVb1TkHwLfuxS7sTRFLuKW2.ozgTHiVD5xv
 Ziko5.yQX504YBXJBBQoa8vzX.j66XKKCkSzVfVjXMyUlnFtjdnqghk_lTd.
 bmYx5IwqcxPlPccCaiCBbM7RhYjser79X6uIVg1YPHPS744MaXWcUvOStmSd
 L7o1h1xINZ3ZTOFZjw2.tUfQaNg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 2 Dec 2011 08:44:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Alex Shi <alex.shi@intel.com>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] slub: remove unnecessary statistics,
 deactivate_to_head/tail
In-Reply-To: <1322814189-17318-2-git-send-email-alex.shi@intel.com>
Message-ID: <alpine.DEB.2.00.1112020844070.10975@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com> <1322814189-17318-2-git-send-email-alex.shi@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Alex Shi wrote:

> Since the head or tail were automaticly decided in add_partial(),
> we didn't need this statistics again.

You need to update tools/slub/slabinfo.c as well.

