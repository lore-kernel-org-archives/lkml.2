Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2F2Rlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:41:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56764 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab2F2Rlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:41:46 -0400
Date: Fri, 29 Jun 2012 18:41:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120629174130.GY14083@ZenIV.linux.org.uk>
References: <20120623210141.GK14083@ZenIV.linux.org.uk>
 <20120624041652.GN14083@ZenIV.linux.org.uk>
 <20120624153310.GB24596@redhat.com>
 <20120625060357.GT14083@ZenIV.linux.org.uk>
 <20120625151812.GA16062@redhat.com>
 <20120627183721.GA23086@redhat.com>
 <20120628043836.GW14083@ZenIV.linux.org.uk>
 <1340947838.2293.2.camel@falcor>
 <20120629083311.GX14083@ZenIV.linux.org.uk>
 <1340974925.2309.13.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340974925.2309.13.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 09:02:05AM -0400, Mimi Zohar wrote:

> In addition to failing with my tailored .config (eg. IMA, TPM builtin),
> it fails with config-3.4.2-1.fc16.x86_64, with new default options,
> running on a Lenovo W520.
> 
> /dev/sda7 on / type ext4 (rw,relatime,seclabel,i_version,data=ordered)

Lovely...  Smells like something making dracut unhappy.  Does it say
anything interesting when booting with rdinitdebug in command line?
What happens with rdshell in there?

I don't have easily accessible Fedora boxen at the moment and it does
look like something fishy going on while initramfs stuff runs...
