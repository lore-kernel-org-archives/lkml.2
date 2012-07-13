Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab2GMXIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 19:08:04 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:31992
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab2GMXIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 19:08:02 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.229;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail02v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1202hzzz2fh2a8h668h839hd25hf0ah107ah)
Message-ID: <5000AA38.5010508@am.sony.com>
Date: Fri, 13 Jul 2012 16:07:36 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Paul Bolle <pebolle@tiscali.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <20120713210240.GG1707@redhat.com> <1342216225.15453.15.camel@x61.thuisdomein> <20120713215546.GH1707@redhat.com>
In-Reply-To: <20120713215546.GH1707@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/12 14:55, Dave Jones wrote:
> On Fri, Jul 13, 2012 at 11:50:25PM +0200, Paul Bolle wrote:
> 
>  > But just removing all the certainly unused macros probably wouldn't have
>  > made a noticeable difference to anyone using those defconfig files
>  > anyway.
> 
> My point is that I don't think there's many people actually using them.
> (maybe more on the niche platforms, but x86[64] ? I'm sceptical they're used at all)

I'm one of those people who use default configs.  I build a given kernel version for
many different embedded boards and expect the default config to work for them.  It
makes life much easier.

I also share Linus' pain when building for my host x86 system and try to
remove the cruft from my distro config.

-Frank

