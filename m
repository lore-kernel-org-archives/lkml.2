Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2JSFYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 01:24:02 -0400
Received: from www84.your-server.de ([213.133.104.84]:43751 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2JSFYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 01:24:00 -0400
Message-ID: <1350624189.14741.1.camel@wall-e>
Subject: Re: [PATCH] remove untouched code in kfifo_in
From: Stefani Seibold <stefani@seibold.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        jkosina@suse.cz
Date: Fri, 19 Oct 2012 07:23:09 +0200
In-Reply-To: <CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com>
References: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
	 <CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Freitag, den 19.10.2012, 00:37 +0200 schrieb richard -rw- weinberger:
> On Thu, Oct 18, 2012 at 3:59 PM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:
> > In kfifo_in marco, one piece of code is arounded by if(0). This code in
> > introduced by Stefani Seibold <stefani@seibold.net> to suppress a compiler
> > warning. This warning is not there with the upgrade of gcc version.
> >
> > This patch just remove this code.
> 
> Are you sure?
> This code fragment looks like a compiler bomb to detect type mismatch to me...
> 

Yes, you are great! That was the reason why i made this peace of code.
So don't remove it!

