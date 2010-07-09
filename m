Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0GIXZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:25:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48491 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab0GIXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RaXW1Rent1f68vxmNl8o0CF+c+Vvmc2B3jZZyjOnNEi+0p0qdT3tHzyIs/pU6pvIFb
         Y/QRjxJ5GoGmmuZ5HxjCcWFhe/ki8LceKxCuAVtpbe3yJS8whXcylVLfelt/gJSNdRMG
         tXxWTb9eotD5hd2aBfKrdU7jSUyf4xM2tsepk=
Date: Sat, 10 Jul 2010 01:25:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 1/8] do_coredump: do not take BKL
Message-ID: <20100709232523.GB5269@nowhere>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de> <1278194552-24943-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278194552-24943-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 12:02:25AM +0200, Arnd Bergmann wrote:
> core_pattern is not actually protected and hasn't been
> ever since we introduced procfs support for sysctl -- a
> _long_ time. Don't take it here either.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---


Applied in bkl/core, thanks.

