Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab2EGT4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:56:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab2EGT4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:56:32 -0400
Date: Mon, 7 May 2012 12:56:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: android: logger: Allocate logs dynamically at
 boot
Message-ID: <20120507195628.GA9977@kroah.com>
References: <4FA4673C.7010209@am.sony.com>
 <20120504233707.GA24213@kroah.com>
 <4FA8195E.2010706@am.sony.com>
 <20120507185852.GA1838@kroah.com>
 <4FA81EFC.5000405@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA81EFC.5000405@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 12:14:04PM -0700, Tim Bird wrote:
> BTW, I have a whitespace cleanup for one of my previous patches.  I'm unsure
> if I should send this in, or wait until the code in question is affected
> by another patch.  I thought the standard kernel policy was to not do
> standalone whitespace cleanup patches (especially trivial ones).  But
> is that the same policy for staging?

No, the policy is to do stand-alone whitespace cleanup patches,
especially trivial ones :)

Well, for portions of the kernel I maintain at least, I don't mind them
at all, send them on when you have them.

thanks,

greg k-h
