Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242Ab1EAQwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:52:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50839 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1EAQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zj4BEqLkiTMc+5UYv+sKO3UjLyTXpM6elLIEpId8sex3BvQ6SmwS/h4wOoLPRWB39q
         qG1avlrtxmF57+72rHzDso3Wi10od9wW7QKySViCTLABBfDng4YWLZ2+m+zGR6lv1hOj
         6I02ZaHBLHjEWbZXwWhwW8P/GTe3wiKK8t5MU=
Date: Sun, 1 May 2011 09:52:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Panic in input handling
Message-ID: <20110501165245.GB23240@core.coreip.homeip.net>
References: <20110429102343.5ee9e34c@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429102343.5ee9e34c@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:23:43AM -0700, Jesse Barnes wrote:
> Just booted up a relatively fresh kernel and hit this when trying to
> shut down X; maybe it's been fixed already?  I'd be happy to try any
> patches...
> 

Hmm, haven't seen this one yet and that part of code did not change for
a while. Is it reproducible?

Thanks.

-- 
Dmitry
