Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0CVU7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab0CVU66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:58:58 -0400
Date: Mon, 22 Mar 2010 20:58:21 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100322205821.GF28709@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7AF2D.7060306@redhat.com> <4BA7C1D7.5070208@codemonkey.ws> <4BA7CC5C.3020008@nagafix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7CC5C.3020008@nagafix.co.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 03:00:28AM +0700, Antoine Martin wrote:
> On 03/23/2010 02:15 AM, Anthony Liguori wrote:
> >On 03/22/2010 12:55 PM, Avi Kivity wrote:
> >>>Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by 
> >>>Anthony.
> >>>There's numerous ways that this can break:
> >>
> >>I don't like it either.  We have libvirt for enumerating guests.
> >
> >We're stuck in a rut with libvirt and I think a lot of the 
> >dissatisfaction with qemu is rooted in that.  It's not libvirt that's 
> >the probably, but the relationship between qemu and libvirt.
> +1
> The obvious reason why so many people still use shell scripts rather 
> than libvirt is because if it just doesn't provide what they need.
> Every time I've looked at it (and I've been looking for a better 
> solution for many years), it seems that it would have provided most of 
> the things I needed, but the remaining bits were unsolvable.

If you happen to remember what missing features prevented you choosing
libvirt, that would be invaluable information for us, to see if there
are quick wins that will help out. We got very useful feedback when
recently asking people this same question

http://rwmj.wordpress.com/2010/01/07/quick-quiz-what-stops-you-from-using-libvirt/

Allowing arbitrary passthrough of QEMU commands/args will solve some of
these issues, but certainly far from solving all of them. eg guest cut+
paste, host side control of guest screen resolution, easier x509/TLS 
configuration for remote management, soft reboot, Windows desktop support
for virt-manager, host network interface management/setup, etc

Regards,
Daniel
-- 
|: Red Hat, Engineering, London    -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org -o- http://virt-manager.org -o- http://deltacloud.org :|
|: http://autobuild.org        -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-   F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
