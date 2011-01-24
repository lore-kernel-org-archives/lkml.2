Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1AXRzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:55:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48585 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab1AXRzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:55:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TNek4j1w72FNNKQzUKErWmLHxdc58l3+piuvapfXhDqkOdxR7tcPc3jk53DyVUvB2/
         s46hB1ce5jILMXhdj1yu7FXgyAmJvwinpmozCmafK6H+2Ux0i9WlJrICOWgJ7Lke0UYE
         F5xB0n3w439QMRI4Tink9j72fQEwwLvlYcxQ4=
Date: Mon, 24 Jan 2011 09:54:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110124175456.GA17855@core.coreip.homeip.net>
References: <4D3C5F73.2050408@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3C5F73.2050408@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Jan 23, 2011 at 12:03:47PM -0500, Mark Lord wrote:
> As of the 2.6.36 kernel, the userspace commands lsinput and input-kbd
> no longer work.  And if I grab newer/patched versions of those from the latest
> Ubuntu 10.10, then those newer/patched versions do not work with kernels
> *before* 2.6.36.
> 
> At first glance, this looks like a visible regression.
> Is there a version of input-utils that works with both
> old and new kernels ?
> 

The event protocol number was updated to reflect support of large
scancodes, unfortunately some of the utilities expected exact version
and refuse to work with updated one. Ubuntu's fix was simply recompile
the code using the new define, this make it work on newer kernels but of
course broke the old ones...

-- 
Dmitry
