Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0HXRJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:09:09 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:29775 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755751Ab0HXRJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:09:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CASrb.MVM1nstCAve1KAo3ptKyxsX84n1nGkc0woxR38OEq
 laSTKJMOcMA_jnQaLevEZSKYYMPRkcPFZgbrq4tdfY3RboFT6UH9Z4sU92E4
 kAG3yhB9Fa.QpO0QfwHZVRpbBaGLBO_JjcvYBTeWmJjiMFZPouiEp0Sq.DC9
 tFxkQDKNnMSbHOoTBffVbKR25a132HPV5NXrBNzjlUtTPCGVhOzh.5vY6l5A
 rxFoyrTX0Y4cDLLgyFlt3Yr9Q4lAVOsAN
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 24 Aug 2010 12:09:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 2/2] compaction: fix COMPACTPAGEFAILED counting
In-Reply-To: <1282664620-4539-1-git-send-email-minchan.kim@gmail.com>
Message-ID: <alpine.DEB.2.00.1008241207130.3695@router.home>
References: <1282664620-4539-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Minchan Kim wrote:

> This patch makes new rule for caller of migrate_pages to call putback_lru_pages.
> So caller need to clean up the lists so it has a chance to postprocess the pages.
> [suggested by Christoph Lameter]

Acked-by: Christoph Lameter <cl@linux.com>
