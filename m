Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab1IBAKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:10:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45347 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659Ab1IBAKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:10:38 -0400
Date: Thu, 1 Sep 2011 17:09:58 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vasiliy Kulikov <segoon@openwall.com>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Serge Hallyn <serge@hallyn.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-ID: <20110902000958.GE1919@count0.beaverton.ibm.com>
References: <20110831075814.003575573@openvz.org>
 <20110831080229.100652529@openvz.org>
 <20110831090612.GA3253@albatros>
 <20110831112642.GI25465@sun>
 <20110831140416.GA17626@shutemov.name>
 <20110831142622.GB30615@sun>
 <20110831151023.5b7e12da.akpm@linux-foundation.org>
 <4E5F3B25.9030701@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5F3B25.9030701@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 11:58:29AM +0400, Pavel Emelyanov wrote:
> > What additional kernel patches are required to bring that effort to a
> > usable state and where are those patches?
> 
> * The one you've already accepted with ->statfs for pipefs.
> * PTRACE_SEIZE set from Tejun (RFC was sent some time earlier)
> * CLONE_USEPID flag for the clone() syscall (Cyrill will re-send a bit later)

Is that the last CLONE_ flag? Does it fully support nesting of pid namespaces?

What happened to the idea of using the existing eclone patches instead?

Cheers,
	-Matt Helsley
