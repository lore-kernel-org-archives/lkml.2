Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1I0UPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:15:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:35650 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1I0UPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:15:04 -0400
Message-ID: <4E822EB8.5030901@windriver.com>
Date: Tue, 27 Sep 2011 16:14:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Igor M. Liplianin" <liplianin@netup.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
References: <20110927161055.05bbb0586fffbfbb2307f30b@canb.auug.org.au>
In-Reply-To: <20110927161055.05bbb0586fffbfbb2307f30b@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-09-27 02:10 AM, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/misc/altera-stapl/altera.c between commit cff4fa8415a3 ("[media]
> altera-stapl: it is time to move out from staging") from the v4l-dvb tree
> and commit 99c978529a40 ("staging: Add module.h to drivers/staging
> users") from the staging tree.

Hey Greg/Stephen,

So that I could revalidate the module.h stuff with randconfig builds,
I've taken the above staging commit and re-applied it to the module.h
tree -- I'm pretty sure git will see it as the same commit and just
move on with no complaints, but just a heads up for Stephen in case.

This won't happen until Stephen takes the module.h from one of our
internal servers as a temporary measure while kernel.org is down.
I'll be sending that information to linux-next and Stephen later
today.

Paul.

> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
> 
> Mauro, you could, of course, apply Paul's patch to the file in its new
> location.
