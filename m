Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1HaUOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:14:36 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:55749 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753882Ab1HaUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:14:33 -0400
Date: Wed, 31 Aug 2011 13:14:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-ext4@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: Tree for Aug 30 (jbd2 + bug.h)
Message-Id: <20110831131429.0513af51.rdunlap@xenotime.net>
In-Reply-To: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:

> Hi all,

[Sorry about the delay.  My build machine is being slow.
If this is alread fixed, sorry about the noise.]


When CONFIG_BUG is not enabled (I see this on x86_64):

fs/jbd2/transaction.c: In function 'jbd2_journal_dirty_metadata':
fs/jbd2/transaction.c:1176: error: implicit declaration of function '__WARN'


asm-generic/bug.h does not provide a version of __WARN() when
CONFIG_BUG is not enabled...


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
