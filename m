Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab0CVLKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:10:42 -0400
Received: from 8bytes.org ([88.198.83.132]:49450 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0CVLKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:10:41 -0400
Date: Mon, 22 Mar 2010 12:10:40 +0100
From: oerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100322111040.GL13108@8bytes.org>
References: <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100321203121.GA30194@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 09:31:21PM +0100, Ingo Molnar wrote:
> Lets see one example of that thought process in action: Oprofile.

Since you are talking so much about oProfile in this thread I think it
is important to mention that the problem with oProfile was not the
repository separation.

The problem was (and is) that the kernel and the user-space parts are
maintained by different people who dont talk to each other or have a
direction where they want to go with the project. Basically the reason
of the oProfile failure is a disfunctional community. I told the
kernel-maintainer several times to also maintain user-space but he
didn't want that.

The situation with KVM is entirely different. Avi commits to kvm.git and
qemu-kvm.git so he maintains both. Anthony is working to integrate the
qemu-kvm changes into upstream qemu. Further these people work very
closely together and the community around KVM works well too. The
problems that oProfile has are not even in sight for KVM.

	Joerg

