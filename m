Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2EaPPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:15:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41046 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab2EaPPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:15:47 -0400
Date: Thu, 31 May 2012 20:43:10 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH] tty: annotate tty_lock() for lockdep
Message-ID: <20120531151310.GD24279@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <alpine.LNX.2.00.1205282042290.15057@pobox.suse.cz>
 <20120531113115.GA1548@linux.vnet.ibm.com>
 <1338465354.2760.1336.camel@edumazet-glaptop>
 <20120531132106.GB24279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120531132106.GB24279@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053115-6148-0000-0000-0000064D1A52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srikar Dronamraju <srikar@linux.vnet.ibm.com> [2012-05-31 18:51:06]:

> > > 
> > > I saw a similar problem and applied your patch, but that doesnt seem to
> > > help me.
> > 
> > I was not aware of Jiri patch
> > 
> > Try this one instead :
> > 
> > https://lkml.org/lkml/2012/5/31/125
> > 
> 
> Yes, this works for me.
> 

Just to update, I saw the problem on 3 different boxes on 3 different archs and your patch fixes it on all  of them.

-- 
Thanks and Regards
Srikar

