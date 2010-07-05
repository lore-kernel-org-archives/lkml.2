Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0GETXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:23:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60235 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0GETXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hNpSMLOAp65YT8qZdytPces6D26osHZYdwu48ApYUVYRmdyNDB+viuMgVhlMlXb1hS
         qOQw1hN+TLeizCkLTvlgyqXodnXRAc1PuHXrLvOykEsXnSPRv5JKVZ1pehCnwPwipxyX
         VW10MKlm/YDI7jHWPUMwSv27hZTLG5L1/nujY=
Date: Mon, 5 Jul 2010 21:24:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ian Kent <raven@themaw.net>, autofs@linux.kernel.org
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Message-ID: <20100705192358.GC5240@nowhere>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <1278195310-25590-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278195310-25590-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 12:15:07AM +0200, Arnd Bergmann wrote:
> Handling of autofs ioctl numbers does not need to be generic
> and can easily be done directly in autofs itself.
> 
> This also pushes the BKL into autofs and autofs4 ioctl
> methods.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: H. Peter Anvin <hpa@zytor.com>



Peter, if you're fine with this version. May I apply it?
Unless you have a tree for autofs.

Thanks.

