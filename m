Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1DEPHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:07:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42400 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1DEPHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CuDRwJJcNYbfgF+y/vazEq2K94ug1ugoqDQsz+RV47/+01qnghWcu5dUcuJmq9hnMW
         KzQeQE/GN9KcG0sxWVeUoiQGHPjaTNWUtTKmjNrB1NHi64Qorrox3Y10p+rjhEZ0kqWy
         lgr6oZkHONwB9WZmhcXwJje4d97vJidX8PVG4=
Subject: Re: [PATCH 16/34] nand/denali: Drop __TIME__ usage
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
In-Reply-To: <1302015561-21047-17-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	 <1302015561-21047-17-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 18:02:47 +0300
Message-ID: <1302015767.2760.145.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 16:59 +0200, Michal Marek wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: Chuanxiao Dong <chuanxiao.dong@intel.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Do you want this to got via the MTD tree or you'd rather merge it with
the rest of the patches via some other tree? In any case,

Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

