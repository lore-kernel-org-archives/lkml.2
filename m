Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1JQQeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:34:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:59963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1JQQeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:34:23 -0400
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Date: Mon, 17 Oct 2011 18:33:59 +0200
In-Reply-To: <20111017164839.3887ee3e@lxorguk.ukuu.org.uk>
References: <1318837019.6594.29.camel@twins>
	 <alpine.LFD.2.02.1110171119580.3240@ionos>
	 <20111017124647.GA12838@srcf.ucam.org> <1318856786.4172.22.camel@twins>
	 <20111017141147.GA14581@srcf.ucam.org> <1318861707.4172.32.camel@twins>
	 <20111017144013.GA15447@srcf.ucam.org> <1318862969.4172.45.camel@twins>
	 <20111017145952.GB15769@srcf.ucam.org> <1318864260.4172.54.camel@twins>
	 <20111017151920.GA16664@srcf.ucam.org> <1318864870.4172.61.camel@twins>
	 <20111017164839.3887ee3e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318869239.4172.64.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 16:48 +0100, Alan Cox wrote:
> > Hard enforcement is very much better than papering over because it makes
> > the individual developer instantly aware that he's got a problem.
> 
> Not always
> 
> If you do weird container crap with timers than app authors will simply
> point out that the weird container crap is buggy as it works properly in
> a normal environment.

Oh agreed. I never said the hard enforcement would/should rely on
container crap. I'm very much in favour of a machine that's fully
functional with a CGROUP=n kernel, thank you very much.

Sadly a number of (userspace) wankers (some included on this thread)
seem hell bent on making that impossible.
