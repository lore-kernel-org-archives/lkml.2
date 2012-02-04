Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2BDCPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 21:15:05 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37645 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684Ab2BDCPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 21:15:03 -0500
X-Sasl-enc: uuPzYEPx3R8RLB8pqX5B8CaUnCLERhvJaiHGJrQoqQjX 1328321701
Date: Sat, 4 Feb 2012 00:14:57 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jiri Slaby <jslaby@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>
Subject: Re: network regression: cannot rename netdev twice
Message-ID: <20120204021457.GA25386@khazad-dum.debian.net>
References: <4F27120A.4040106@suse.cz>
 <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
 <4F27C54F.1010107@suse.cz>
 <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012, Kay Sievers wrote:
> Please make sure nothing tries to swap netif names in userspace. We
> have given up that approach, because it is far too fragile to
> temporary rename devices to be able to swap the names, and race
> against the loading of new kernel network drivers at the same time.

That's a damn fair reason, but the loss of that functionality could cause
trouble.  In fact, at first glance, to me it looks like this has a large
potential for unleashing untold pain and suffering in the sysadmin ranks
unless early userspace can emulate it somehow.

Is it possible to configure the kernel to use something other than "eth#" as
its initial namespace for netif names?  Or is there some other way to get
eth1 to be what you need eth1 to be during userland boot?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
