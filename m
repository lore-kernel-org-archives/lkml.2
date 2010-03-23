Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab0CWDCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:02:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0CWDCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:02:03 -0400
X-Authority-Analysis: v=1.0 c=1 a=q7Hbh6cPxJoA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=5ag6DWIdFaIrk0IvKGQA:9 a=bgzrCrVhw_ENPQP7A6qSFyLqkzcA:4 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 12/18] timer: Provide config option for enabling timer
 tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1003230300480.3147@localhost.localdomain>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
	 <1269304340-25372-13-git-send-email-jack@suse.cz>
	 <alpine.LFD.2.00.1003230300480.3147@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 22 Mar 2010 23:01:59 -0400
Message-ID: <1269313319.2957.447.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 03:01 +0100, Thomas Gleixner wrote:
> On Tue, 23 Mar 2010, Jan Kara wrote:
> 
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Steven, can you pick that up please ?

I assume this is dependent on the first patch. I made some comments to
that one, and was hoping to get some better comments in the code before
doing anything with it.

-- Steve



