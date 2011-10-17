Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1JQQtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:49:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48600 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1JQQtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:49:46 -0400
Date: Mon, 17 Oct 2011 17:49:29 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Message-ID: <20111017164929.GA18620@srcf.ucam.org>
References: <20111017141147.GA14581@srcf.ucam.org>
 <1318861707.4172.32.camel@twins>
 <20111017144013.GA15447@srcf.ucam.org>
 <1318862969.4172.45.camel@twins>
 <20111017145952.GB15769@srcf.ucam.org>
 <1318864260.4172.54.camel@twins>
 <20111017151920.GA16664@srcf.ucam.org>
 <1318864870.4172.61.camel@twins>
 <20111017153142.GA17047@srcf.ucam.org>
 <1318869404.4172.67.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318869404.4172.67.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 06:36:44PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-17 at 16:31 +0100, Matthew Garrett wrote:
> > On Mon, Oct 17, 2011 at 05:21:10PM +0200, Peter Zijlstra wrote:
> > 
> > > Well what other cases are there? Can we enumerate them and come up 
> > > with similar solutions?
> > 
> > Javascript has timers. We execute rather a lot of javascript from 
> > sources we can't influence at all.
> 
> Which brings me to yet another gripe I've got with firefox, _WHY_ does
> it run javascript for tabs I can't see? Simply freeze the interpreter.

Because people expect gmail to provide them with status updates even if 
it's not the foreground tab.

> Then again, what does JavaScript do with these timers? I don't really
> see how javascript/random-native-binary are really different, something
> needs doing. What something?

I agree that the thing that needs doing probably involves web developers 
and threats of implied violence, but I suspect that web developers are 
being created faster than we can reeducate them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
