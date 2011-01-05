Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1AEH7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:59:38 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56989 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1AEH7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:59:36 -0500
Date: Wed, 5 Jan 2011 16:57:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] sh: correct definitions to access stack pointers
Message-ID: <20110105075737.GB23889@linux-sh.org>
References: <4D1F7434.4090108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1F7434.4090108@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 01, 2011 at 07:36:36PM +0100, roel kluin wrote:
> A definition like:
> 
> #define regs_return_value(regs)	((regs)->regs[0])
> 
> called with regs_return_value(foo) will be preprocessed to:
> 
> ((foo)->foo[0])
>         ^^^
> So to fix this to ensure the preprocessor compiles such calls correctly.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks.
