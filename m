Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1AHEOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 23:14:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49533 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1AHEOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 23:14:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hr2AOmyr+XIBYYxWOPkubJszGDVWjI97xzbwePgDkS3UFRoAksqk2QrF+RUpiqkJOu
         8AyxRBSHi+goR2EUKYj4UKpKUu2JUXdTevDon/2hlDOWBMfvNq+D//USKE9fZwww5gv4
         2JXuqbOPz+QfJgj/4NKbmHLrVXM7Z7T3ILhE4=
MIME-Version: 1.0
In-Reply-To: <20110106154757.75fb6b2a.akpm@linux-foundation.org>
References: <AANLkTinOPuYsVovrZpbuCCmG5deEyc8WgA_A1RJx_YK7@mail.gmail.com>
	<20110106154757.75fb6b2a.akpm@linux-foundation.org>
Date: Sat, 8 Jan 2011 12:14:15 +0800
Message-ID: <AANLkTi=A9eNzgtE=mxZcDT+-5eDHGihsu=DD3xO5KvpH@mail.gmail.com>
Subject: Re: [PATCH] sched: fix strncmp operation
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 7:47 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> Just remove the strstrip(), I'd say.  The kernel practically never
> strips leading whitespace from sysfs input, so why do it here?
>

Would you please, Andrew, take another glance at the patch for
replacing ida in workqueue?

              https://lkml.org/lkml/2010/12/18/35

thanks
Hillf
