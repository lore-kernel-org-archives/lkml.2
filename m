Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0LCRME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:12:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab0LCRMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:12:02 -0500
Date: Fri, 3 Dec 2010 18:11:48 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Maxim Uvarov <muvarov@gmail.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101203171147.GA2299@redhat.com>
References: <20101203111623.GA2741@redhat.com>
 <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 06:46:09PM +0300, Maxim Uvarov wrote:
> 2010/12/3 Stanislaw Gruszka <sgruszka@redhat.com>:
> > On my T-60 laptop, i686 system with 2.6.37-rc4 kernel,
> > "echo c > /proc/sysrq-trigger" just hung the system. Kdump
> > works on 2.6.36. Is this known issue? If not, what info
> > I should provide to solve it (I think the easiest way
> > to solve the problem would be bisect) ?
> >
> > Stanislaw
> >
> 
> I tested x86 QEMU yesterday with the latest git. It worked.
> Might be something target specific.., What does console print?

Here is the photo 
http://people.redhat.com/sgruszka/20101203_005.jpg

There are two BUGs, first "sleeping function called from invalid
context" and then "unable to handle null pointer dereference".

Stanislaw
