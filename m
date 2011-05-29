Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab1E2Voc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:44:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49656 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1E2Vob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:44:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 29 May 2011 23:44:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: August Lilleaas <august@augustl.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Firewire: net: replacing deprecated
 __attribute__((packed)) with __packed
Message-ID: <20110529234416.7f6f2d53@stein>
In-Reply-To: <1306688839-18732-1-git-send-email-august@augustl.com>
References: <1306688839-18732-1-git-send-email-august@augustl.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 29 August Lilleaas wrote:
> Fixing a deprecation, replacing __attribute__((packed)) with __packed.

Who deprecated it and why?

Shouldn't you add "#include <linux/compiler.h>" now?
-- 
Stefan Richter
-=====-==-== -=-= ===-=
http://arcgraph.de/sr/
