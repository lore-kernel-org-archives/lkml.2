Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1CJJtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:49:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46305 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1CJJta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:49:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bzMrhRmhY3eHAKWUQ7hYgoeo7K6cMYfZuUXPmpwetDkX8c2YCsHNvAfWYfl5nxvGzh
         8yXHqtSNbBszJFWjie0/lvw/FlPPJ2oc/FraKiBAy3q6tvmMUOlvJcOSo/u+CZ05o6os
         rOmTKuliZ/icmhbxPMtuDlI8dydIUWd/y30ng=
Date: Thu, 10 Mar 2011 12:49:23 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: James Morris <jmorris@namei.org>
Cc: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, arnd@arndb.de, mirqus@gmail.com,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com, kees.cook@canonical.com,
        eugene@redhat.com, dan.j.rosenberg@gmail.com
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev
 kernel modules
Message-ID: <20110310094923.GA3945@albatros>
References: <20110301213313.GA6507@albatros>
 <4D6DEE7C.6020700@msgid.tls.msk.ru>
 <20110309220633.GA14750@albatros>
 <20110309.140928.70185544.davem@davemloft.net>
 <alpine.LRH.2.00.1103100953330.4485@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1103100953330.4485@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

On Thu, Mar 10, 2011 at 09:53 +1100, James Morris wrote:
> I can submit it via my tree.

Thank you!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
