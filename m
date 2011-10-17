Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab1JQQhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:37:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49985 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1JQQhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:37:03 -0400
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
Date: Mon, 17 Oct 2011 18:36:44 +0200
In-Reply-To: <20111017153142.GA17047@srcf.ucam.org>
References: <20111017124647.GA12838@srcf.ucam.org>
	 <1318856786.4172.22.camel@twins> <20111017141147.GA14581@srcf.ucam.org>
	 <1318861707.4172.32.camel@twins> <20111017144013.GA15447@srcf.ucam.org>
	 <1318862969.4172.45.camel@twins> <20111017145952.GB15769@srcf.ucam.org>
	 <1318864260.4172.54.camel@twins> <20111017151920.GA16664@srcf.ucam.org>
	 <1318864870.4172.61.camel@twins> <20111017153142.GA17047@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318869404.4172.67.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 16:31 +0100, Matthew Garrett wrote:
> On Mon, Oct 17, 2011 at 05:21:10PM +0200, Peter Zijlstra wrote:
> 
> > Well what other cases are there? Can we enumerate them and come up 
> > with similar solutions?
> 
> Javascript has timers. We execute rather a lot of javascript from 
> sources we can't influence at all.

Which brings me to yet another gripe I've got with firefox, _WHY_ does
it run javascript for tabs I can't see? Simply freeze the interpreter.

Then again, what does JavaScript do with these timers? I don't really
see how javascript/random-native-binary are really different, something
needs doing. What something?


