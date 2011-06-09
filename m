Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1FIJFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:05:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:56801 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab1FIJFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:05:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sven Anders <anders@anduras.de>
Subject: Re: [PATCH 3/5] v2 =?utf-8?b?c2VjY29tcF9maWx0ZXJzOg==?= Enable ftrace-based system call filtering
Date: Thu, 9 Jun 2011 09:00:32 +0000 (UTC)
Message-ID: <loom.20110609T105102-215@post.gmane.org>
References: <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com> <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net> <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com> <20110525201927.GA8397@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 77.21.181.137 (Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.17) Gecko/20110422 Ubuntu/9.10 (karmic) Firefox/3.6.17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo <at> elte.hu> writes:

> <flame>
> 
> IMHO the key design mistake of LSM is that it detaches security 
> policy from applications: you need to be admin to load policies, you 
> need to be root to use/configure an LSM. Dammit, you need to be root 
> to add labels to files!
> 
> This not only makes the LSM policies distro specific (and needlessly 
> forked and detached from real security), but also gives the message 
> that:
> 
>  'to ensure your security you need to be privileged'
> 
> which is the anti-concept of good security IMO.
> 
> [....]
> </flame>
> 
> Thanks,
> 	Ingo


Hello!
An incomplete idea I had some time ago:

Couldn't the security information (like the selinux profiles) be
part of the binaries?

Each source package should deliver it's own security information
and this should be better than adding it later, because the 
developer of the program knows, what his program should be allowed
to do. Moreover, if the developer changes something, he can/must
add the security information altogether.

Of course these information has to be signed in some way to
avoid tampering.

Just an idea...


