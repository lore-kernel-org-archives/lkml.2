Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1A0BWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:22:42 -0500
Received: from smtp-out.google.com ([74.125.121.67]:55703 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1A0BWg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:22:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CkTKN3OjZHZGqdLJhnz13XoWKIGMi10poF2omJ5GywBVShY4mi9lN6gJb3wO5z9Ze9
         Quh4/z5kDwLNFW38EDfg==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
 <20110125031752.GA9846@kroah.com> <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
 <20110126024608.GB28283@kroah.com> <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Wed, 26 Jan 2011 17:22:11 -0800
Message-ID: <AANLkTimT_t-3smsaQUrtisFdkODfoOoroQ93tQ9PByBq@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
To: Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 3:58 PM, Mike Waychison <mikew@google.com> wrote:
> On Tue, Jan 25, 2011 at 6:46 PM, Greg KH <greg@kroah.com> wrote:
>> So, let me ask, what specifically are you wanting to import/export
>> to/from the kernel here?  Have you thought about other kernel/user apis
>> instead of ioctls?  What is forcing you to use ioctls?
>
> I'm not sure if you are trying to suggest that there is a better way
> to solve these problems without actually saying so.  We could probably
> use a different interface, sure.
>

Well, I managed to find efivars.c, and it seems like I can probably
massage it to do what I want as several of the calls I'd like to
export to userland mirror portions of the EFI runtime services page.
That won't take care of all of the firmware calls I'd like to export,
but it's a start.
