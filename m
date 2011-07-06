Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1GFQPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:15:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63776 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab1GFQP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110706155745.GB16625@suse.de>
References: <20110706074934.GA935@mail.fossee.in> <20110706155745.GB16625@suse.de>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Wed, 6 Jul 2011 21:45:08 +0530
Message-ID: <CAD6i1fK0nH+D3v+A3erC1PgR=S=709H9ZC=T8-q0gqV1ghA0bQ@mail.gmail.com>
Subject: Re: [PATCH] Staging: msm: fixed style issues found by checkpatch.pl
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> So that would be one patch for fixing extra braces, one for extra
> spaces, and so on.  That makes it easier to review.

Ok I will redo them.

On Wed, Jul 6, 2011 at 9:27 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Jul 06, 2011 at 01:19:34PM +0530, Prashant P. Shah wrote:
> Also, did you successfully build this code before and after your
> changes?

I tried but the code does not build because of #include <mach/board.h>
in the msm_fb.c file. I dont know how to fix that.
