Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2IZLka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:40:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51044 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab2IZLk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:40:29 -0400
Date: Wed, 26 Sep 2012 13:40:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Unspaghettize do_trap()
Message-ID: <20120926114024.GA26353@gmail.com>
References: <1348577479-2564-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348577479-2564-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +		return -1

this bit wasn't very well tested. I applied it with the obvious 
fix, lets hope it holds up in testing.

Thanks,

	Ingo
