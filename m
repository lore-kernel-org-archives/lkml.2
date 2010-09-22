Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab0IVXZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:25:48 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:39043 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782Ab0IVXZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:25:47 -0400
Date: Wed, 22 Sep 2010 16:24:58 -0700
From: matt mooney <mfm@muteddisk.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: rtl8187se: r8180.h: fixed alot of
 checkpatch.pl issues
Message-ID: <20100922232458.GB18432@haskell.muteddisk.com>
Mail-Followup-To: Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
	linux-kernel@vger.kernel.org
References: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:19 Mon 20 Sep     , Tracey Dent wrote:
> Fixed numerous coding style issues
> 
The subject should be more specific as to what the patch does, such as
"Staging: rtl8187se: r8180.h: whitespace cleanup."

And the explanation in the commit should also be more specific. There are
plenty of examples if you look through the log. Greg might except them as is,
but any future patches should follow the advice mentioned. Next time for a
patch of this nature remember to CC kernel-janitors too. 

Thanks,
mfm
