Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1JQPSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:18:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38927 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab1JQPSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:18:50 -0400
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Date: Mon, 17 Oct 2011 17:18:33 +0200
References: <20111017032232.GA4816@srcf.ucam.org>
	 <4E9BBB6D.4050004@linux.intel.com> <1318837019.6594.29.camel@twins>
	 <alpine.LFD.2.02.1110171119580.3240@ionos>
	 <20111017124647.GA12838@srcf.ucam.org> <1318856786.4172.22.camel@twins>
	 <20111017141147.GA14581@srcf.ucam.org> <1318861707.4172.32.camel@twins>
	 <20111017144013.GA15447@srcf.ucam.org> <1318862969.4172.45.camel@twins>
	 <20111017145952.GB15769@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318864713.4172.59.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 17:11 +0200, Peter Zijlstra wrote:
> For a while people were promoting the idea that its good to be lenient
> in what you accept as input and strict in what you send out. I think
> people are starting to realize that was a horrid mistake since now
> they're getting utter crap and people don't even know what right is
> anymore. 

Since different apps might have treated similar non-conformant input
differently and now no single behaviour is correct.

I think either dhowells or dwmw2 had a good blog post on that a while
back.
