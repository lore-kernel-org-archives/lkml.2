Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2GYIBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:01:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32895 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755575Ab2GYIBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:01:23 -0400
Message-ID: <1343203282.30161.29.camel@joe2Laptop>
Subject: Re: [PATCH] fixed coding style issues
From: Joe Perches <joe@perches.com>
To: Baodong Chen <chenbdchenbd@gmail.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jul 2012 01:01:22 -0700
In-Reply-To: <CAEAuANO7itUw64z=w9ve_suvQBoPirnmZ_5WBbc=Tn=ESeG6OA@mail.gmail.com>
References: <1343200277-14385-1-git-send-email-chenbdchenbd@gmail.com>
	 <1343201406.30161.10.camel@joe2Laptop>
	 <CAEAuANO7itUw64z=w9ve_suvQBoPirnmZ_5WBbc=Tn=ESeG6OA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 15:44 +0800, Baodong Chen wrote:
> i want to participate in and to start from
> fixing simple issues!

That's fine Baodong.  Welcome.

> how could i choose issues form checkpatch's output to find which
> should be fixed which are
> not?

checkpatch output is merely a guide for submission of patches
to conform to some generic "kernel style".  I think there are
times when really ugly code should have a pass to make it more
"kernel style" like.  Most of those cleanup type changes should
be done only to code in the "drivers/staging" directory.

I think most of the time, unless you are also fixing some other
underlying code defect or shortcoming, checkpatch only cleanups
to existing code are best avoided.

I suggest for now, until you are really comfortable with the
preferred style, you confine yourself to drivers/staging.

> or checkpatch.pl should be updated??

You could work on that too.

One possibility is to write a utility to take checkpatch output
and generate patches automatically, or perhaps extend checkpatch
itself to do that.  (ie: add a --fix option)

cheers, Joe

