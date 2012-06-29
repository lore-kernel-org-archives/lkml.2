Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2F2Vlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 17:41:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55850 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab2F2Vlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 17:41:45 -0400
Message-ID: <1341005929.2194.9.camel@falcor.watson.ibm.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Fri, 29 Jun 2012 17:38:49 -0400
In-Reply-To: <20120629174130.GY14083@ZenIV.linux.org.uk>
References: <20120623210141.GK14083@ZenIV.linux.org.uk>
	 <20120624041652.GN14083@ZenIV.linux.org.uk>
	 <20120624153310.GB24596@redhat.com>
	 <20120625060357.GT14083@ZenIV.linux.org.uk>
	 <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com>
	 <20120628043836.GW14083@ZenIV.linux.org.uk>
	 <1340947838.2293.2.camel@falcor>
	 <20120629083311.GX14083@ZenIV.linux.org.uk>
	 <1340974925.2309.13.camel@falcor>
	 <20120629174130.GY14083@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12062921-2398-0000-0000-000008061FAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 18:41 +0100, Al Viro wrote:
> On Fri, Jun 29, 2012 at 09:02:05AM -0400, Mimi Zohar wrote:
> 
> > In addition to failing with my tailored .config (eg. IMA, TPM builtin),
> > it fails with config-3.4.2-1.fc16.x86_64, with new default options,
> > running on a Lenovo W520.
> > 
> > /dev/sda7 on / type ext4 (rw,relatime,seclabel,i_version,data=ordered)
> 
> Lovely...  Smells like something making dracut unhappy.  Does it say
> anything interesting when booting with rdinitdebug in command line?
> What happens with rdshell in there?
> 
> I don't have easily accessible Fedora boxen at the moment and it does
> look like something fishy going on while initramfs stuff runs...

No difference with rdinitdebug, rdshell, but the message 
"ata5: SATA link down (SStatus 0 SControl 300)" prior to "Freeing unused
kernel memory... ", "Failed to execute /init" and the trace back,
probably helps.  Don't know how I missed that.

Mimi

