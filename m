Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2JOQWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:22:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2JOQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:22:17 -0400
Date: Mon, 15 Oct 2012 09:22:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d reverts
 unrelated changes
Message-ID: <20121015162213.GA32049@kroah.com>
References: <507C475502000078000A17AA@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507C475502000078000A17AA@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 04:26:45PM +0100, Jan Beulich wrote:
> Michal,
> 
> is there any reason why that commit reverts two other changes
> (to arch/x86/Makefile and scripts/Makefile.fwinst) without any
> mention of the reason for this in the description?
> 
> Also, Greg, didn't this get merged into stable a little too quickly?

What type of information in this patch would have kept me from merging
it quickly?  How am I supposed to know that?

greg k-h
