Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287Ab2JWUte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:49:34 -0400
Received: from mail.x86-64.org ([217.9.48.20]:56316 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757519Ab2JWUtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:49:32 -0400
Date: Tue, 23 Oct 2012 22:49:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Message-ID: <20121023204926.GA20787@aftab.osrc.amd.com>
References: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
 <20121023121005.ed33061a.akpm@linux-foundation.org>
 <20121023202612.GA20526@aftab.osrc.amd.com>
 <20121023133709.21e9cb72.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023133709.21e9cb72.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:37:09PM -0700, Andrew Morton wrote:
> This is still strange. What's the point in having the initial loop
> even consider the last element in the array if we know we'll be using
> it anyway?

You're right, yours is better.

Now you only need to give me a proper patch with your S-O-B and we're
ready to go :).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
