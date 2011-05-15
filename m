Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab1EONyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 09:54:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38036 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab1EONyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 09:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WpBizjbKfpHbNo0JU/TF6FRCNrYfQWNvZNK8zzxCIS9mwomb1x8QkfyToLhznyuV5r
         WO428KKxTRmrytvk4jvRhx7/Qx/EsbN7bXOzGAcOUhmTXz1P72E7iuMSEL24NMLdg8DA
         HODkoyRDijpT2cPNF/Wmpt/XXLLuk/hnZEJRE=
Date: Sun, 15 May 2011 15:53:59 +0200
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39-rc7
Message-ID: <20110515135359.GE23665@htj.dyndns.org>
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
 <20110515135037.GA26111@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515135037.GA26111@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 15, 2011 at 03:50:37PM +0200, Borislav Petkov wrote:
> On Mon, May 09, 2011 at 07:49:48PM -0700, Linus Torvalds wrote:
> > But please do test, just to make sure that 39-final is good.
> 
> I'm hitting a warn_on in the gendisk events code; happens after plugging
> an ipod through usb. Adding Tejun.
> 
> [49739.003946] WARNING: at block/genhd.c:1556 disk_clear_events+0xca/0x101()

Welcome to the party. :-)

The bug is being tracked in bug#34662.

 https://bugzilla.kernel.org/show_bug.cgi?id=34662

I thought that I got it but apparently my fix didn't work.  I'll get
back to it first thing tomorrow.  Can you please cc yourself to the
bug?

Thank you.

-- 
tejun
