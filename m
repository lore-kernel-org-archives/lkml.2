Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0FUD6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 23:58:32 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40080 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0FUD6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 23:58:30 -0400
Date: Mon, 21 Jun 2010 12:58:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] arch/sh/mm: Eliminate a double lock
Message-ID: <20100621035809.GB29997@linux-sh.org>
References: <Pine.LNX.4.64.1006201324360.4366@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006201324360.4366@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 01:24:54PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The function begins and ends with a read_lock.  The latter is changed to a
> read_unlock.
> 
Indeed, good catch. Applied, thanks.
