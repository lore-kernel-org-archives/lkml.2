Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab0DHTtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:49:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933211Ab0DHTti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:49:38 -0400
Date: Thu, 8 Apr 2010 12:48:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: yauhen.kharuzhy@promwad.com, linux-kernel@vger.kernel.org,
       Jeff Mahoney <jeffm@suse.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH] IIO: Fix adding more than one iio device eventset
Message-Id: <20100408124843.ed53e39d.akpm@linux-foundation.org>
In-Reply-To: <4BBCCBDC.8080609@cam.ac.uk>
References: <1270652625-30640-1-git-send-email-yauhen.kharuzhy@promwad.com>
	<4BBCCBDC.8080609@cam.ac.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Apr 2010 19:15:56 +0100
Jonathan Cameron <jic23@cam.ac.uk> wrote:

> Thanks for the patch.  The first bug was fixed by a patch from Sonic Zhang.
> Andrew Morton picked it up so it is in the mm tree.  Thanks for the report
> of this particularly horrible bug though as had been there quite a while before
> Sonic pointed it out!

hm.  Is it a "horrible bug"?  I had assumed that it was a minor bug and
had staged the patch for 2.6.35.  Was that a mistake?
