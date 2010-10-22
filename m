Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab0JVOdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:33:52 -0400
Received: from [85.183.114.52] ([85.183.114.52]:41709 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757226Ab0JVOdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:33:51 -0400
Date: Fri, 22 Oct 2010 16:34:16 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Joern Engel <joern@lazybastard.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block2mtd: dubious assignment
Message-ID: <20101022143416.GA12737@logfs.org>
References: <20101022124724.59eba464@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101022124724.59eba464@absol.kitzblitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 October 2010 12:47:24 +0200, Nicolas Kaiser wrote:
> 
> When block2mtd_erase fails, a duplicated assignment instantly
> changes instr->state from MTD_ERASE_FAILED to MTD_ERASE_DONE.
> 
> It looks to me like this might not be intended, or is it?

Definitely not.  Just proves how well block device errors are tested.

> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Acked-By: Joern Engel <joern@logfs.org>

Artem, can I leave this patch to you as well?

Jörn

-- 
Eighty percent of success is showing up.
-- Woody Allen
