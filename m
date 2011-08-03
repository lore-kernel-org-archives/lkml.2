Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1HCVMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:12:35 -0400
Received: from matrixpower.ru ([195.178.208.66]:32833 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752956Ab1HCVMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:12:31 -0400
Date: Thu, 4 Aug 2011 01:12:25 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] connector: add comm change event report to proc
 connector
Message-ID: <20110803211225.GA24876@ioremap.net>
References: <1312310811-17327-1-git-send-email-vzapolskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312310811-17327-1-git-send-email-vzapolskiy@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 09:46:51PM +0300, Vladimir Zapolskiy (vzapolskiy@gmail.com) wrote:
> This change adds an event to monitor comm value changes of tasks. Such
> an event becomes vital, if someone desires to control threads of a
> process in different manner.


> Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Looks good.
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
