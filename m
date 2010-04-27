Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0D0HYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:24:51 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39779 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0D0HYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:24:50 -0400
Subject: Re: [PATCH 2/3] drivers/mtd/maps: Eliminate use after free
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1004021447160.17695@ask.diku.dk>
References: <Pine.LNX.4.64.1004021447160.17695@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 10:19:36 +0300
Message-ID: <1272352776.26036.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Apr 2010 07:23:47.0334 (UTC) FILETIME=[9379BA60:01CAE5DA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 14:47 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Moved the debugging message before the call to map_destroy, which frees its
> argument.  The message is also slightly changed to reflect its new
> position.
> 
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

