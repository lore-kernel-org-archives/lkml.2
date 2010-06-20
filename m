Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0FTNvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 09:51:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48561 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535Ab0FTNvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 09:51:48 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Julia Lawall <julia@diku.dk>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] arch/sh/mm: Eliminate a double lock
In-Reply-To: <Pine.LNX.4.64.1006201324360.4366@ask.diku.dk>
References: <Pine.LNX.4.64.1006201324360.4366@ask.diku.dk>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Sun, 20 Jun 2010 14:51:46 +0100
Message-ID: <87lja9q0b1.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 13:24:54 +0200 (CEST), Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The function begins and ends with a read_lock.  The latter is changed to a
> read_unlock.

I think we've been quite lucky here so far, in that no one takes a
write_lock after we've double-read-locked pmb_rwlock.

Acked-by: Matt Fleming <matt@console-pimps.org>
