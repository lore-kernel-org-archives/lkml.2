Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1GRPSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:18:20 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:32943 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751291Ab1GRPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:18:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eIcBdsuQme4z4/jfp0+FwT9bAGmZu3kIAyCUSUnFZFXDDpCQ2wJP0uZMXN5vK3wkITzLjX4VJd4rqOVH/4XPfSOceOfnMjYRnUZd3DTL5jV6AQ4EJ63Y48kiHT96222Q;
Date: Mon, 18 Jul 2011 08:18:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for July 18 (mm/truncate.c)
Message-Id: <20110718081816.2106117e.rdunlap@xenotime.net>
In-Reply-To: <20110718203501.232bd176e83ff65f056366e6@canb.auug.org.au>
References: <20110718203501.232bd176e83ff65f056366e6@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011 20:35:01 +1000 Stephen Rothwell wrote:

> Hi all,

mm/truncate.c:612: error: implicit declaration of function 'inode_dio_wait'

mm/truncate.c should be #include-ing <linux/fs.h> for that function's
prototype, but that doesn't help when CONFIG_BLOCK is not enabled,
which is the case in this build failure.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
