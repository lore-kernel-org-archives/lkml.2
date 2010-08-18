Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0HRRPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:15:09 -0400
Received: from mail.perches.com ([173.55.12.10]:1160 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab0HRRPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:15:07 -0400
Subject: RE: [PATCH] fs.h: introduce functions to get/set file->private_data
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@infradead.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
In-Reply-To: <0D753D10438DA54287A00B0270842697643E5A1CDF@AUSP01VMBX24.collaborationhost.net>
References: <201008161137.53187.hartleys@visionengravers.com>
	 <20100816231753.GA16546@infradead.org>
	 <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
	 <1282002601.6518.116.camel@Joe-Laptop> <20100817010355.GG21182@thunk.org>
	 <20100817085428.GA25330@infradead.org>
	 <1282065973.24541.106.camel@Joe-Laptop>
	 <20100817175851.GA11463@merkur.ravnborg.org>
	 <1282095142.6724.11.camel@Joe-Laptop>
	 <0D753D10438DA54287A00B0270842697643E5A1CDF@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 10:15:05 -0700
Message-ID: <1282151705.6724.100.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 11:48 -0500, H Hartley Sweeten wrote:
> FWIW, the only reason for bringing this up in the first place was I was
> trying to find all the places that have unnecessary casts when using
> the private_data.  Stuff like:
> 
> 	struct my_struct *my_data = (struct my_struct *)file->private_data;
> 
> Maybe it would be simpler to use spatch to just fix those?

I submitted that patch last month.  About half have been applied.

(I generally link to lkml.org, but it seems down)
http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-07/msg04333.html

I also delete the remaining casts in this conversion.


