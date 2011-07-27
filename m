Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1G0Q2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:28:07 -0400
Received: from lucidpixels.com ([72.73.18.11]:58946 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab1G0Q2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:28:06 -0400
Date: Wed, 27 Jul 2011 12:28:05 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
In-Reply-To: <20110727160752.GC974@fieldses.org>
Message-ID: <alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan> <20110727160752.GC974@fieldses.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jul 2011, J. Bruce Fields wrote:

> On Wed, Jul 27, 2011 at 09:54:09AM -0400, Justin Piszcz wrote:
>> Hi,
>>
>> Kernel 2.6.30 on client.
>> Kernel 2.6.28 on server.
>>
>> p34 kernel: [92223.918892] NFS: directory motion/cam2 contains a
>> readdir loop.  Please contact your server vendor.  Offending cookie: 10272
>
> What filesystem on the server are you exporting?

Hi,

xfs.
/dev/sda1 on / type xfs (rw,noatime)

Nothing special, thoughts?

Justin.

