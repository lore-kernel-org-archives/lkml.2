Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2CAIXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:23:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35341 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2CAIXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:23:44 -0500
Message-ID: <4F4F3205.1050202@kernel.dk>
Date: Thu, 01 Mar 2012 09:23:33 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Muthu Kumar <muthu.lkml@gmail.com>, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, Matt Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
References: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com> <CA+55aFwnF9Vu3JU6wuGMSeSiQqXrH+hqsZ2Ux79+2eH3A+_5MA@mail.gmail.com>
In-Reply-To: <CA+55aFwnF9Vu3JU6wuGMSeSiQqXrH+hqsZ2Ux79+2eH3A+_5MA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 01:08 AM, Linus Torvalds wrote:
> On Wed, Feb 29, 2012 at 3:22 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>> Fix setting bio flags in drivers (sd_dif/floppy).
> 
> A quick grep seems to agree that these are the only obvious ones.
> 
> Jens? Will you send this to me, or should I take it directly?

Which ever one comes first. I've got a few other items queued up that I
will send shortly.

-- 
Jens Axboe

