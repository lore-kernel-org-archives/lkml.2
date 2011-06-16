Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab1FPNeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:34:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57062 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1FPNeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r96GEErs7X4LUYzPap/XqectARcaKMHdSBj+N5A5LHvOAEGZ6VTDPxXNvceuKGf3/U
         7xo1I121lIvueLfvjejlGg0rauk2bLq4fqgTG1b6al7jBFe6yZyVUR7jC9peuGcc+Pxe
         x7MoZxEmU8giqC/6BN8A7W8i1EAvAq0ysmxhQ=
Date: Thu, 16 Jun 2011 17:33:59 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount
 options
Message-ID: <20110616133359.GA12564@albatros>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
 <201106161050.27716.arnd@arndb.de>
 <20110616085842.GB3215@albatros>
 <201106161340.16117.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106161340.16117.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Thu, Jun 16, 2011 at 13:40 +0200, Arnd Bergmann wrote:
> E.g. if all the sensitive information
> you are hiding in procfs is still available through netlink, your patch
> is pointless.

Ah, I've complitely missed this piece of a puzzle! :( With procfs, proc
connector and taskstats (probably, something else) should be restricted
too.

Thank you very much for this notice!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
