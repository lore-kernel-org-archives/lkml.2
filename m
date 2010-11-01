Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab0KAEKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 00:10:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50199 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab0KAEKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 00:10:13 -0400
Date: Mon, 1 Nov 2010 04:10:03 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: New 2.6.36 checkpatch complaints about leading whitespace
Message-ID: <20101101040611.GA5850@penfold>
References: <AANLkTi=sR+wTN1MSRZLW1qB99ybGgOTbUJuw8drtbwA5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=sR+wTN1MSRZLW1qB99ybGgOTbUJuw8drtbwA5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 11:35:22AM +0200, Bart Van Assche wrote:
> Hello Andy,
> 
> Apparently the checkpatch.pl script as included in 2.6.36 complains if
> continued lines start with whitespace. An example:
> 
> [ ... ]
> +#if defined(MACRO_NAME_1) || defined(MACRO_NAME_2) \
> +  || defined(MACRO_NAME_3)
> [ ... ]
> 
> checkpatch.pl reports the following warning for the above patch excerpt:
> 
> WARNING: please, no space for starting a line,
>                                 excluding comments
> 
> Is that a feature or an unintended side effect of recent checkpatch changes ?

My personal expectation would be for that second line to be indented
with a tab.  But I might be convinced otherwise?

-apw
