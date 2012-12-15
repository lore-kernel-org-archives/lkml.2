Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2LORZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 12:25:44 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:50714 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab2LORZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 12:25:42 -0500
Date: Sat, 15 Dec 2012 18:25:40 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Ding <dinggnu@gmail.com>
Subject: Re: [PATCH 1/2 v3] Fix memory freeing issues
Message-ID: <20121215172540.GB2589@local>
References: <201212101118.08463.vitas@nppfactor.kiev.ua>
 <201212101144.45967.vitas@nppfactor.kiev.ua>
 <20121213181354.GI4261@local>
 <201212141133.50312.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212141133.50312.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 11:33:50AM +0200, Vitalii Demianets wrote:
> 
> Hans, why do you want to put in this patch, which is dealing with 
> memory-freeing issues only, completely unrelated functional changes?

Because during review of your patch we happened to find another issue
a few lines up and down. Why not fix it on the way?

What I'd like is simply

[PATCH] Fix uio_pdrv_genirq issues

If you like, make it two patches, one with your memory-freeing issue
and one "Remove irq tracking" or something like that. That's just
three or four lines difference, I'd even accept it if it were only
one patch.

I don't want to fix one thing now and leave the other one unresolved.
That would just be a waste of time.

To be clear, I have no objections regarding your memory freeing ideas.

Thanks,
Hans

