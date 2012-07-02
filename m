Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2GBOxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:53:46 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53161 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2GBOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:53:44 -0400
Message-ID: <1341240603.2086.1.camel@falcor>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Mon, 02 Jul 2012 10:50:03 -0400
In-Reply-To: <20120702133329.GH22927@ZenIV.linux.org.uk>
References: <1341014197.2342.7.camel@falcor.watson.ibm.com>
	 <20120630050238.GZ14083@ZenIV.linux.org.uk>
	 <1341172202.2556.13.camel@falcor>
	 <20120701205722.GD22927@ZenIV.linux.org.uk>
	 <1341193591.2249.3.camel@falcor>
	 <20120702034310.GE22927@ZenIV.linux.org.uk>
	 <20120702051155.GF22927@ZenIV.linux.org.uk>
	 <1341229790.2350.1.camel@falcor>
	 <20120702120259.GG22927@ZenIV.linux.org.uk>
	 <1341234091.2166.5.camel@falcor>
	 <20120702133329.GH22927@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070214-6148-0000-0000-00000742C764
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 14:33 +0100, Al Viro wrote:

> Anyway, I've pushed the fix into vfs.git#master.  Should propagate
> to git.kernel.org in a few (commit 2ae9632 is the branch head)

Thanks!  I'm now able to boot with the delayed __fput().

Mimi



