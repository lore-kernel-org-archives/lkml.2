Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077Ab0HFUfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:35:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762053Ab0HFUfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:35:05 -0400
Date: Fri, 6 Aug 2010 13:34:43 -0700
From: Greg KH <gregkh@suse.de>
To: - <kd6lvw@yahoo.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [00/38] 2.6.35.1-stable review
Message-ID: <20100806203443.GA24060@suse.de>
References: <512689.43589.qm@web84207.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <512689.43589.qm@web84207.mail.re3.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:22:10PM -0700, - wrote:
> Does not include the fix to this bug (introduced in 2.6.35.0):
> 
>    https://bugzilla.kernel.org/show_bug.cgi?id=16506
> 
> Affected file:  arch/x86/lib/atomic64_386_32.S
> 
> This issue causes a compile-time blocking failure.  The patch fixes the problem for older versions of BINUTILS equal to or more recent than the minimum required version currently listed in file Documentation/Changes.
> 
> Patch:  https://bugzilla.kernel.org/attachment.cgi?id=27360
> 
> 
> Please include this in 2.6.35.1 and any other affected kernels.
> 
> The problem was introduced on February 24 through March 1, 2010 by multiple commits, starting with commit a7e926abc3adfbd2e5e20d2b46177adb4e313915.
> 

Which exact patch that is in Linus's tree fixes the problem?  Do you
have the git commit id of it?  That's what I need here.

thanks,

greg k-h
