Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1CPVE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:04:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56826 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab1CPVEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:04:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
Date: Wed, 16 Mar 2011 22:03:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, serge@hallyn.com, eparis@redhat.com,
        jmorris@namei.org, eugeneteo@kernel.org, drosenberg@vsecurity.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <1300303907-22627-1-git-send-email-richard@nod.at> <201103162145.45772.arnd@arndb.de> <201103162152.49615.richard@nod.at>
In-Reply-To: <201103162152.49615.richard@nod.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201103162204.00031.arnd@arndb.de>
X-Provags-ID: V02:K0:CAxfWEfQp1NC+RBbVMcvRSHaA2J7lorO/yZNYjqChS+
 vAkQfsK+lCrx0LbtvwamKjb4ERFjVn2V+Lzde1HdyDc9qFCE7n
 S24W1IPBoqS6xJdO+BH1Cc57/b2aNpaYBSawur3LW3LgnlMlwW
 TcxD9Ms0eHqOju/ZBsRjIH4nv6rwDXBsDn5ZI9sQovJXCFoLTn
 Wgp1H2wLQS/8V2/5pQnZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 March 2011 21:52:49 Richard Weinberger wrote:
> Am Mittwoch 16 März 2011, 21:45:45 schrieb Arnd Bergmann:
> > How does this interact with the per-namespace sysctls that Eric
> > Biederman added a few years ago?
> 
> Do you mean CONFIG_{UTS, UPC, USER, NET,}_NS?

I mean specifically e51b6ba07 "sysctl: Infrastructure for per namespace sysctls"
and related patches. I've looked a bit closer there and it seems that
this is only used for network namespaces at the moment.

> > I had expected that any dangerous sysctl would not be visible in
> > an unpriviledge container anyway.
> 
> No way.
> That's why it's currently a very good idea to mount /proc/ read-only into a container.

Ok, I see. 

	Arnd
