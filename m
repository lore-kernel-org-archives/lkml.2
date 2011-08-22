Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1HVWi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:38:28 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:57918 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1HVWi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:38:26 -0400
Subject: Re: [PATCH] firewire-sbp2: fix panic after rmmod with slow targets
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Chris Boot <bootc@bootc.net>
In-Reply-To: <1314045518-50629-1-git-send-email-bootc@bootc.net>
Date: Mon, 22 Aug 2011 23:38:25 +0100
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <811318C8-1FD9-4E67-8346-13CFB69A0AF8@bootc.net>
References: <20110822163526.5b76d535@stein> <1314045518-50629-1-git-send-email-bootc@bootc.net>
To: Chris Boot <bootc@bootc.net>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Aug 2011, at 21:38, Chris Boot wrote:
> +	list_for_each_entry(lu, next, &tgt->lu_list, link) {

That'll teach me for assuming the define had the same number of arguments, and not compile-testing at least... :-(

I'll send rev 3 over shortly.

Chris