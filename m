Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2GSSUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:20:41 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:1892 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482Ab2GSSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:20:38 -0400
Message-ID: <1342722036.26179.40.camel@x61.thuisdomein>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Paul Bolle <pebolle@tiscali.nl>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Date: Thu, 19 Jul 2012 20:20:36 +0200
In-Reply-To: <20120719171918.GD8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <20120713210240.GG1707@redhat.com>
	 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	 <20120719152618.GD16873@home.goodmis.org>
	 <20120719154521.GC8469@zod.bos.redhat.com>
	 <1342714088.12353.33.camel@gandalf.stny.rr.com>
	 <20120719171918.GD8469@zod.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Jul 2012 18:20:36.0789 (UTC) FILETIME=[3197D650:01CD65DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 13:19 -0400, Josh Boyer wrote:
> kconfig already spits out warnings for symbols being selected that
> don't exist.

Does it? Since when does it do that? Or do you mean select in a more
general way (not just meaning Kconfig's "select" statement)?


Paul Bolle

