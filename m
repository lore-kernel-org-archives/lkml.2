Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0GIDwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:52:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0GIDwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JS/FaQ868otQJfvthEtnjUzA0vDKX97ETZXU98u0sBwUvLn9h/14qtw193GJLIOVvp
         32ysfWT2G3WYjY6ewBzhLObkHs73c9MBx9Po3m6IFkXHnwntqnbuY5/scwuYhLSpOpj2
         yV+eNeqJpsbofPXM1jcomdWGeKGlX6D3fYdRc=
Date: Fri, 9 Jul 2010 05:52:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 2/8] init: remove the BKL from startup code
Message-ID: <20100709035227.GN6405@nowhere>
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


I'll queue this one.

Thanks.

