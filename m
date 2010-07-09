Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0GINh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:37:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40723 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab0GINh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t/IUP8OtzWhnIVYarnwvUS0g6mVmdAH4SHhzsGGXgo3Zd0N7sJQFj7ftZtFLFd0Akw
         5zhrR8A0bWBfKdrc50iVgvQy1elD+vyM+b+UlcZ6ISUoue2V7wpZyHSLD8BhCVyut8nl
         90Df3hzJ2YkE7S1UgFaZ/zlIEJ8ipfMQjxOQ8=
Date: Fri, 9 Jul 2010 15:37:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 2/8] init: remove the BKL from startup code
Message-ID: <20100709133744.GF5291@nowhere>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de> <1278194552-24943-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278194552-24943-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 12:02:26AM +0200, Arnd Bergmann wrote:
> I have shown by code review that no driver takes
> the BKL at init time any more, so whatever the
> init code was locking against is no longer there
> and it is now safe to remove the BKL there.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Steven Rostedt <rostedt@goodmis>
> ---



Just trying to find any possible races here but I can't find any
obvious. But I hope other reviewers can give it a look.

In the meantime, I'll queue that in my bkl/core branch so that
it can live some times in linux-next.

Thanks.

