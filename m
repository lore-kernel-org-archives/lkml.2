Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2HSJIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 05:08:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41309 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2HSJIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 05:08:10 -0400
Date: Sun, 19 Aug 2012 12:08:04 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 5/8] UBI: check max_beb_per1024 value in
 ubi_attach_mtd_dev
Message-ID: <20120819120804.15c33931@pixies.home.jungo.com>
In-Reply-To: <1345214124-5478-6-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
	<1345214124-5478-6-git-send-email-richard.genoud@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Fri, 17 Aug 2012 16:35:21 +0200 Richard Genoud <richard.genoud@gmail.com> wrote:
> +	/*
> +	 * A value of 0 is forced to the default value to keep the same
> +	 * behavior between ubiattach command and module parameter
> +	 */

Minor thing.

Since the module parameter is not yet introduced (only in a later
patch), and since last part of sentence isn't that important, I would
simply state:

+	 * Use the default if max_beb_per1024 isn't provided.

or alike.

Regards,
Shmulik
