Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2G1PE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 11:04:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38341 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752449Ab2G1PEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 11:04:25 -0400
Message-ID: <1343487864.2009.11.camel@joe2Laptop>
Subject: Re: [PATCH] floppy: remove duplicated flag FD_RAW_NEED_DISK
From: Joe Perches <joe@perches.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 28 Jul 2012 08:04:24 -0700
In-Reply-To: <20120728114559.GA12184@localhost>
References: <20120728114559.GA12184@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-28 at 19:45 +0800, Fengguang Wu wrote:
> FD_RAW_NEED_DISK | FD_RAW_NEED_DISK 

That's a pretty old defect from kernel 1.1 days.


