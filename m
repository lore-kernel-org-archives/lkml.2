Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544Ab2J3S6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:58:44 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:32841 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965465Ab2J3S6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:58:42 -0400
Date: Tue, 30 Oct 2012 21:56:15 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] zram decompress_page and zram_sysfs patch seriess
Message-ID: <20121030185615.GB2454@swordfish>
References: <20121030090319.GB5052@swordfish.minsk.epam.com>
 <20121030180439.GA3350@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030180439.GA3350@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,
I'm gonna send you 2 zram patches shortly, reviewed by Nitin.

	[PATCH 1/2] zram: factor-out zram_decompress_page() function
	[PATCH 2/2] zram: handle mem suffixes in disk size zram_sysfs parameter


Thanks,
	-ss
