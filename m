Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1AHBco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 20:32:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41834
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab1AHBcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 20:32:43 -0500
Date: Fri, 07 Jan 2011 17:33:15 -0800 (PST)
Message-Id: <20110107.173315.71121000.davem@davemloft.net>
To: gregkh@suse.de
Cc: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, nelhage@ksplice.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [069/152] econet: Do the correct cleanup after an
 unprivileged SIOCSIFADDR.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110107191930.GB16084@suse.de>
References: <20110106002303.148373791@clark.site>
	<20110107191036.GG32717@windriver.com>
	<20110107191930.GB16084@suse.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Fri, 7 Jan 2011 11:19:30 -0800

> On Fri, Jan 07, 2011 at 02:10:36PM -0500, Paul Gortmaker wrote:
>> [[stable] [069/152] econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.] On 05/01/2011 (Wed 16:22) Greg KH wrote:
>> 
>> > 2.6.36-stable review patch.  If anyone has any objections, please let us know.
>> > 
>> > ------------------
>> > 
>> > 
>> > From: Nelson Elhage <nelhage@ksplice.com>
>> > 
>> > [ Upstream commit f24b8bedf70c524775eabd51570c3fa7708a97b7 ]
>> 
>> I think the upstream # got mangled somehow.  Looking at the tree, I
>> think the upstream is 0c62fc6dd02c8d793c75ae76a9b6881fc36388ad.
>> 
>> The ID listed currently gives me a "bad object". 
> 
> Nice catch, I don't know what happened here, must be something in
> David's scripts, not mine :)
> 
> I'll go edit the changelog before I commit it later today, thanks.

That script is called my brain as I generate these by hand. :-)

Thanks for catching this and fixing it.
