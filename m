Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0CSQPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:15:38 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:43906 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0CSQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <1269011916-8836-3-git-send-email-gregkh@suse.de>
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-3-git-send-email-gregkh@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 19 Mar 2010 10:15:16 -0600
X-Google-Sender-Auth: 90166d3f8fdc2cdc
Message-ID: <fa686aa41003190915n5ec4901eya3eaf11f0b8ea63d@mail.gmail.com>
Subject: Re: [PATCH 3/7] uartlite: Fix build on sparc.
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 9:18 AM, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> From: David Miller <davem@davemloft.net>
>
> We can get this driver enabled via MFD_TIMBERDALE which only
> requires GPIO to be on.
>
> But the of_address_to_resource() function is only present on
> powerpc and microblaze, so we have to conditionalize the
> CONFIG_OF probing bits on that.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Hi Greg,

In the end I ended up merging this one through my tree.  I picked it
up when I needed it for my own testing and so it was in my last merge
request for Linus.

g.
