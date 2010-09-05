Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab0IEGet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:34:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:56678 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab0IEGes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:34:48 -0400
Date: Sat, 4 Sep 2010 23:22:55 -0700
From: Greg KH <gregkh@suse.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: CAI Qian <caiqian@redhat.com>, Dave Anderson <anderson@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: crash failure with 2.6.36-rc3 vmcore
Message-ID: <20100905062255.GA18184@suse.de>
References: <20100904175501.GB31733@ericsson.com> <2068181682.121641283656654395.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <20100905050625.GA700@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100905050625.GA700@ericsson.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 10:06:25PM -0700, Guenter Roeck wrote:
> I browsed through the code a bit. Looks like the module owner will need to make
> the necessary changes. The code now seems to depend on kernel internal structure
> elements. Not sure if that is a good idea in the first place. At least for
> the attribute owner it will have to be changed to not depend on its existence.
> 
> Of course, one could also argue that the field should be re-introduced in 
> the kernel to make the utility work w/o changes. However, I don't think it
> would be a good idea to hold the kernel hostage for such problems.

You're kidding, right?  You should have tools flexable to handle the
fact that the internal kernel structures change all the time like this.
If not, your tools are broken.

good luck,

greg k-h
