Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1FOQbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:31:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57302 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab1FOQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UT8lgJFFHRE1VjdaGLhI5ZwTrUmicTjzsrcnhdVoROXfIXiEdDfxt7l+JeCBg2AtEk
         7le6P6a3kxO5bjvc4NMKJEERzXY+g0lFOdPJp/QIq8pkP7muslg9NgsT2nhO7ImbAsqw
         Wv5KD9eTwFC9TYHZ8xcb6H1IxHUZ9+IolD36k=
Date: Wed, 15 Jun 2011 20:31:48 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
        linux-doc@vger.kernel.org
Subject: Re: [RFC 5/5 v3] procfs: add documentation for procfs mount options
Message-ID: <20110615163147.GA17087@albatros>
References: <1308146299-13015-1-git-send-email-segoon@openwall.com>
 <20110615092221.b143c45a.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615092221.b143c45a.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 09:22 -0700, Randy Dunlap wrote:
> On Wed, 15 Jun 2011 17:58:19 +0400 Vasiliy Kulikov wrote:
> > +hidepid=1 means users may not access any /proc/<pid>/ directories, but their
> 
> comma not needed above. [...]

Indeed, thank you for the fixes!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
