Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1F0JVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:21:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38682 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab1F0JUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZwHmRw/PFtkkzf1LFoirPDP/3VRt2X3esoccwqrmfzJOHSywEsxI+z4o7YPDzseDIt
         ezs/VxPVse7gCAkg1LJy6C77r4DTy0nKqmhi1vMSvmDLeZk+kol/OOLjEkFe1/Qh6G44
         rPhkN+H8+4I1Ohmzkf/u23ESdomki+MsAaSPI=
Date: Mon, 27 Jun 2011 13:20:00 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110627092000.GA7263@albatros>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627083633.GA5846@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 12:36 +0400, Vasiliy Kulikov wrote:
> > and the reason for exclusion.
> 
> Note that *you* want to define a black list with a clear denied
> semantics,

Sorry, s/semantics/charsets with a proof of the harm/


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
