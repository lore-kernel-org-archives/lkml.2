Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab2ANStH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 13:49:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098Ab2ANStD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 13:49:03 -0500
Date: Sat, 14 Jan 2012 13:48:55 -0500
From: Dave Jones <davej@redhat.com>
To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] More UBI/UBIFS changes for 3.3
Message-ID: <20120114184854.GA23282@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Bityutskiy, Artem" <artem.bityutskiy@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1326456812.18165.0.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326456812.18165.0.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:11:57PM +0000, Bityutskiy, Artem wrote:
 > Hi Linus,
 > 
 > please pull more UBI/UBIFS changes for 3.3, thanks!
 > 
 > The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
 > 
 >   Linux 3.2 (2012-01-04 15:55:44 -0800)

This introduced a compile failure if CONFIG_UBIFS_FS_DEBUG is unset.

fs/ubifs/journal.c: In function ‘ubifs_jnl_write_data’:
fs/ubifs/journal.c:700:2: error: implicit declaration of function ‘dbg_jnlk’ [-Werror=implicit-function-declaration]

	Dave
