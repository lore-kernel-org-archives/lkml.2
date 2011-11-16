Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1KPHmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:42:31 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38445 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200Ab1KPHma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:42:30 -0500
X-Sasl-enc: uQ1SwdhvkGCYCW7WUgn9ZA/gCnilSZz97GSTowWpXhNu 1321429348
Message-ID: <4EC36963.9000300@ladisch.de>
Date: Wed, 16 Nov 2011 08:42:27 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix truncated entity specification
References: <4EB5ADA9.6010104@ladisch.de> <201111150148.07957.laurent.pinchart@ideasonboard.com> <4EC262DD.1070502@ladisch.de> <201111160133.04816.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111160133.04816.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> > > On Saturday 05 November 2011 22:42:01 Clemens Ladisch wrote:
> > > > When enumerating an entity, assign the entire entity specification
> > > > instead of only the first two words.  (This requires giving the
> > > > specification union a name.)
> 
> Your patch looks good then, except that I would memcpy to u_ent.raw instead of
> u_ent.v4l. Would you also be ok with shortening specification to spec (or
> info) ?

Yes, go ahead.


Regards,
Clemens
