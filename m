Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1EDU7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:59:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754253Ab1EDU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:59:29 -0400
Date: Wed, 4 May 2011 13:58:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 -next] LEDS: LED module of DA9052 PMIC driver
Message-Id: <20110504135833.c44c372d.akpm@linux-foundation.org>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8D9@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8D9@KCINPUNHJCMS01.kpit.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 14:53:58 +0530
Ashish Jangam <Ashish.Jangam@kpitcummins.com> wrote:

> LED Driver for Dialog Semiconductor DA9052 PMICs.

I don't know what to do with this patch.

> +	depends on PMIC_DA9052

Because it is unusable as a standalone patch.


What is your merge plan for PMIC_DA9052 support?  Please work one out,
and tell us about it in each and every patch so that the people who are
receiving these emails can work out what to do with them.

