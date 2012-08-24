Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab2HXSTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:19:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab2HXSTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:19:42 -0400
Date: Fri, 24 Aug 2012 14:19:40 -0400
From: jbaron <jbaron@redhat.com>
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jim.cromie@gmail.com
Subject: Re: About multiple queries to control using
 $DBGMT/dynamic_debug/control
Message-ID: <20120824181939.GB6197@redhat.com>
References: <201208221942104377284@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208221942104377284@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 07:42:14PM +0800, Jianpeng Ma wrote:
> Hi,
> 	I used the $DBGMT/dynamic_debug/control to control printing debuginfo.But When i wote multiple queries which has at least one didn't match,
> the result is ok which no error can return.
> 	So i think i wrote correct queries.But until using dmesg, i only found error.
> 	And if parm verbose of dynamic_debug is zero, i can't find the result by dmesg.
> 	So i think it's not convenient.
> 	If it did not found any query,it should return error.
> 
> Thanks!

Hi,

You can verify what changes have occured by looking in the
$DBGMT/dynamic_debug/control file, and verifying what statements have
been matched. For example, we add a 'p' when printing is enabled.
Does that address your concern?

As these debug statements come and go, I think I'd prefer not to error
out in this case.

Thanks,

-Jason
