Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0JUP2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:28:46 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:28248 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751865Ab0JUP2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:28:44 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: y4XgbU8VM1kVBSxaS7NqWqpHF_9xZJLP79MjwWjtm889P_S
 _R6fG1qz0ld.klEgjiHiJJK5cuAHPoBq9KZ73U6TBLLZK2WMpZGoM178FB8Q
 ZNLtD7R5LBK4MjAY5JKwWfQA2.2lNj_I0B.S.mjCYG74x_yA0S1WoPBHDnwU
 O20g.qAGaLArGWIoJ9uRAL3cBpOS.APFysBfk_7LWZATXTBqtWeMt1TTJPXr
 HmWxUXcSdiAwwgkVnSDcBxvX.2t4pi8Pf1A--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 21 Oct 2010 10:28:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: npiggin@kernel.dk
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 13/14] fs: icache split IO and LRU lists
In-Reply-To: <20101021131017.274548424@kernel.dk>
Message-ID: <alpine.DEB.2.00.1010211018250.24115@router.home>
References: <20101021130829.442910807@kernel.dk> <20101021131017.274548424@kernel.dk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, npiggin@kernel.dk wrote:

> Split inode reclaim and writeback lists in preparation to scale them up
> (per-bdi locking for i_io and per-zone locking for i_lru)

Why per zone and not per node? Is there any chance of having lru lists for
ZONE_NORMAL and ZONE_DMA?
