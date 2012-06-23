Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2FWCzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 22:55:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2FWCzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 22:55:24 -0400
Date: Fri, 22 Jun 2012 19:55:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Custom kernel version numbers
Message-ID: <20120623025520.GB18260@kroah.com>
References: <4FE4F0DA.6080304@spin.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE4F0DA.6080304@spin.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 08:25:30AM +1000, Chris Jones wrote:
> Is there a general rule against giving a version number to a custom
> kernel if credit is given to the base kernel version?

You have the code, you can number it however you want.

But, if you want others to have some clue as to what kernel you are
running for whatever reason (support, community help with problems,
etc.) I would recommend using the kernel.org release numbers and adding
onto that like all of the major Linux distros do already.

What were you thinking of numbering your kernel?

greg k-h
