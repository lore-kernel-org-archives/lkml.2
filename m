Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab0IUGX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:23:58 -0400
Received: from ist.d-labs.de ([213.239.218.44]:56050 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab0IUGX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:23:57 -0400
Date: Tue, 21 Sep 2010 08:23:53 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, greg@kroah.com,
        stefanr@s5r6.in-berlin.de, broonie@opensource.wolfsonmicro.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] scripts/get_maintainer.pl: fix .mailmap handling
Message-ID: <20100921082353.4bb85271@schatten.dmk.lab>
In-Reply-To: <1285046435.25988.131.camel@Joe-Laptop>
References: <1285021645-14311-1-git-send-email-florian@mickler.org>
	<1285022156-14501-1-git-send-email-florian@mickler.org>
	<1285028085.25988.60.camel@Joe-Laptop>
	<20100921065921.03f06293@schatten.dmk.lab>
	<1285046435.25988.131.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 22:20:35 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2010-09-21 at 06:59 +0200, Florian Mickler wrote:

> @ret is not descriptive.
> Yeah, it's an array.
> An array of what?
> btw: @list was sub-optimal too.

:) ok. 

> As we discussed privately, yes, .mailmap handling was broken
> but both of us seem to think that it's not even necessary as
> most .mailmap entries are created manually and it's not
> up-to-date.  Name de-duplication is more effective.

No, no. I think .mailmap mangling should be applied before grouping 

name <address>  

together by name.


> And, I do ack a patch after I think it is ready to be applied.
> Until then, I note what I see as shortcomings and defects.

I send the patch with the removed #print as a reply. 

> 
> cheers, Joe
> 

Regards,
Flo
