Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0IUXoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:44:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab0IUXoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:44:01 -0400
Date: Tue, 21 Sep 2010 16:43:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: olivers137@aol.com, wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] it87_wdt: Add support for watchdogs with 8b timers
Message-Id: <20100921164350.82de425e.akpm@linux-foundation.org>
In-Reply-To: <20100914005416.GB25251@localhost>
References: <20100914005416.GB25251@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 02:54:16 +0200
Ondrej Zajicek <santiago@crfreenet.org> wrote:

> +static int wdt_round_time(int t)
> +{
> +	t += 59;
> +	t -= t % 60;
> +	return t;
> +}

fwiw, we could use kernel.h's roundup() here.
