Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab1HIBzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 21:55:31 -0400
Received: from tundra.namei.org ([65.99.196.166]:60251 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab1HIBza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 21:55:30 -0400
Date: Tue, 9 Aug 2011 11:53:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: Re: [PATCH v7 00/16] EVM
In-Reply-To: <1311108971.3374.17.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1108091152280.27255@tundra.namei.org>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>  <alpine.LRH.2.00.1107190948540.16033@tundra.namei.org> <1311108971.3374.17.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011, Mimi Zohar wrote:

> If/when you're ready to merge the EVM patches, they have been rebased
> against the latest security-testing-2.6/#next and a couple of
> whitespaces removed.  No other changes were made.
> 
> The following changes since commit 0f2a55d5bb2372058275b0b343d90dd5d640d045:

Merged with a couple of fixups into:

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next



-- 
James Morris
<jmorris@namei.org>
