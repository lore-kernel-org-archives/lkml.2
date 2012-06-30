Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2F3AN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:13:57 -0400
Received: from kanga.kvack.org ([205.233.56.17]:56043 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab2F3ANy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:13:54 -0400
Date: Fri, 29 Jun 2012 20:13:50 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
Message-ID: <20120630001350.GS21968@kvack.org>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk> <20120629.153656.1141845894730637434.davem@davemloft.net> <20120629231236.GA28593@mail.collabora.co.uk> <20120629.161821.948325645333976311.davem@davemloft.net> <20120629234230.GA11480@kyllikki.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629234230.GA11480@kyllikki.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2012 at 12:42:30AM +0100, Vincent Sanders wrote:
> The current users are suffering from the issues outlined in my
> introductory mail all the time. These issues are caused by emulating an
> IPC system over AF_UNIX in userspace.

Nothing in your introductory statements indicate how your requirements 
can't be met through a hybrid socket + shared memory solution.  The IPC 
facilities of the kernel are already quite rich, and sufficient for 
building many kinds of complex systems.  What's so different about DBus' 
requirements?

		-ben
-- 
"Thought is the essence of where you are now."
