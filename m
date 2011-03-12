Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1CLDy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 22:54:59 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:2093 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1CLDy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 22:54:58 -0500
X-Loopcount0: from 143.166.82.43
Date: Fri, 11 Mar 2011 21:54:56 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 00/12] google firmware support
Message-ID: <20110312035456.GA508@auslistsprd01.us.dell.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 05:42:55PM -0800, Mike Waychison wrote:
> Patchset summary
> ================
> 
> Patches [1 through 6] refactor the 'efivars' module to let the "gsmi"
> driver in patch [11] re-use the variable functionality.
>
> Patch [7] documents existing 'efivars' functionality that has been
> present in the tree since 2004.

Very nice work Mike.  I can't test the efivars changes for another
week or more, but reading it all, looks like a nice cleanup while
allowing you to reuse the underlying code.


Thanks,
Matt

-- 
Matt Domsch
Technology Strategist
Dell | Office of the CTO
