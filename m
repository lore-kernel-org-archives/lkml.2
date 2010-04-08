Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0DHIMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:12:54 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59844 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab0DHIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:12:51 -0400
Subject: Re: [PATCH 1/2] mtdpart: memory accessor interface for MTD layer
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-mtd@lists.infradead.org, Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       David Brownell <david-b@pacbell.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       David Howells <dhowells@redhat.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1268772081-6534-1-git-send-email-khilman@deeprootsystems.com>
References: <1268772081-6534-1-git-send-email-khilman@deeprootsystems.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 11:10:13 +0300
Message-ID: <1270714213.6754.97.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Apr 2010 08:11:59.0124 (UTC) FILETIME=[29449D40:01CAD6F3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 13:41 -0700, Kevin Hilman wrote:
> From: Sudhakar Rajashekhara <sudhakar....@ti.com>
> 
> This patch implements memory accessor interface in the MTD
> layer which enables the kernel to access flash data.
> 
> This patch adds two new members to the mtd_partition structure,
> a function handler which will be called during setup of the
> partition and an argument to be passed to this setup function.

I've pushed this one to my l2-mtd-2.6.git tree, branch "dunno".

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

