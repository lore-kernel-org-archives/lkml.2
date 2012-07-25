Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab2GYIZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:25:51 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62930 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748Ab2GYIZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <1343203282.30161.29.camel@joe2Laptop>
References: <1343200277-14385-1-git-send-email-chenbdchenbd@gmail.com>
	<1343201406.30161.10.camel@joe2Laptop>
	<CAEAuANO7itUw64z=w9ve_suvQBoPirnmZ_5WBbc=Tn=ESeG6OA@mail.gmail.com>
	<1343203282.30161.29.camel@joe2Laptop>
Date: Wed, 25 Jul 2012 16:25:47 +0800
Message-ID: <CAEAuANOJaVb2prSMF4N4zxKTAxpEWvmdOPFODQNAR+fFo3hKEA@mail.gmail.com>
Subject: Re: [PATCH] fixed coding style issues
From: Baodong Chen <chenbdchenbd@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 4:01 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-07-25 at 15:44 +0800, Baodong Chen wrote:
>> i want to participate in and to start from
>> fixing simple issues!
>
> That's fine Baodong.  Welcome.
>
>> how could i choose issues form checkpatch's output to find which
>> should be fixed which are
>> not?
>
> checkpatch output is merely a guide for submission of patches
> to conform to some generic "kernel style".  I think there are
> times when really ugly code should have a pass to make it more
> "kernel style" like.  Most of those cleanup type changes should
> be done only to code in the "drivers/staging" directory.
>
> I think most of the time, unless you are also fixing some other
> underlying code defect or shortcoming, checkpatch only cleanups
> to existing code are best avoided.
>
> I suggest for now, until you are really comfortable with the
> preferred style, you confine yourself to drivers/staging.
>
hi,Joe;
thank for your explaining!
ok, i will start from drivers/staging

>> or checkpatch.pl should be updated??
>
> You could work on that too.
>
> One possibility is to write a utility to take checkpatch output
> and generate patches automatically, or perhaps extend checkpatch
> itself to do that.  (ie: add a --fix option)
>
> cheers, Joe
>
