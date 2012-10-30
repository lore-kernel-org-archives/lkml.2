Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab2J3Kpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:45:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab2J3Kps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:45:48 -0400
Message-ID: <1351593902.7863.0.camel@turiel>
Subject: Re: Nouveau regression between 3.6 and 3.7-rc3: driver stuck at
 "running init tables"
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 20:45:02 +1000
In-Reply-To: <20121030080319.GA31945@kashmir>
References: <20121029230647.GA10369@kashmir>
	 <1351552559.3810.2.camel@turiel> <20121029233237.GA10839@kashmir>
	 <1351573979.3810.4.camel@turiel> <20121030080319.GA31945@kashmir>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 09:03 +0100, Mathieu Chouquet-Stringer wrote:
> On Tue, Oct 30, 2012 at 03:12:59PM +1000, Ben Skeggs wrote:
> > Not sure what's up with the hang yet, however, I noticed the issue [1]
> > which is likely causing the error messages from nouveau's i2c code.
> > With some luck, it'll stop triggering whatever bug is making it hang in
> > the VBIOS init table parser.
> 
> Just tested that and it works (TM).  So yeah, that fixed it.  Thanks.
Excellent, thanks!  I'll get it into my next -fixes pull.

> 
> Reported-by: Mathieu Chouquet-Stringer <mathieu@csetco.com>
> Tested-by: Mathieu Chouquet-Stringer <mathieu@csetco.com>
> 


