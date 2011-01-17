Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1AQIcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:32:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab1AQIcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=b4i2Z6HvIleRvL96yK9uA61nYSqHRPltg2CMyHzck2NnSlGOTPaWByQ0I30JqiEGlb
         VO2ZjISLHuBh2jGcEE3NPQk15Z4uy/VO0XgKPCMapmaS2ef7QAtORFwtCKOkmmIATXUf
         yYQIKUqGFENfk7WuMA92N4qdaFC82NVGVjuso=
Date: Mon, 17 Jan 2011 08:32:08 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: NETLINK: Failed to browse: Invalid argument from avahi-daemon
	in F14 since 2.6.37-git8
Message-ID: <20110117083208.GA7569@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinHOFwPCwJNCy9cFMCf+_VNb-7YFk-3VJFXoaoZ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-15 19:34, Alessandro Suardi wrote:
> /var/log/messages says:
> 
> Jan 13 12:42:02 duff avahi-daemon[2771]: Found user 'avahi' (UID 70)
> and group 'avahi' (GID 70).
> Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully dropped root privileges.
> Jan 13 12:42:02 duff avahi-daemon[2771]: avahi-daemon 0.6.27 starting up.
> Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully called chroot().
> Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully dropped
> remaining capabilities.
> Jan 13 12:42:02 duff avahi-daemon[2771]: Loading service file
> /services/ssh.service.
> Jan 13 12:42:02 duff avahi-daemon[2771]: Loading service file
> /services/udisks.service.
> Jan 13 12:42:02 duff avahi-daemon[2771]: NETLINK: Failed to browse:
> Invalid argument
> Jan 13 12:42:23 duff acpid: starting up with netlink and the input layer
> 
> 
> Happens both at boot and after boot if restarting avahi-daemon service,
>  and there is a 10-15" wait before the service start script prints a [FAILED]
>  red tag; avahi-daemon process does start up anyways.
> 
> -git7 is the latest "good" kernel
> -git8, -git9, -git11, -git13 have been reproducing the issue
> 
> 
> thanks, ciao,

Seems to be resolved in this thread:

http://www.spinics.net/lists/netdev/msg152762.html

Thanks,
Jarek P.
