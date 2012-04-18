Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2DRXcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:32:10 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:61342 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2DRXcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:32:08 -0400
Date: Wed, 18 Apr 2012 16:32:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: light: isl29028: fix correct mask value
Message-ID: <20120418233205.GA23280@kroah.com>
References: <1334591862-5169-1-git-send-email-ldewangan@nvidia.com>
 <f9fb01a9-362a-4540-9547-63263a4ca10e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9fb01a9-362a-4540-9547-63263a4ca10e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 05:08:07PM +0100, Jonathan Cameron wrote:
> 
> 
> Laxman Dewangan <ldewangan@nvidia.com> wrote:
> 
> >The mask value in the read_raw/write_raw is absolute
> >value, not the bit position value.
> >Fixing this in the implemented function to check value,
> >not with the bit position value.
> Oops I should have caught that.
> Sorry 
> >
> >Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: <jic23@kernel.org>

You need to put your name here, not just an email address :)

