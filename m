Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1A3VtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 16:49:12 -0500
Received: from relay10.uol.com.br ([200.147.1.0]:56631 "EHLO
	relay10.uol.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1A3VtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 16:49:10 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jan 2011 16:49:10 EST
X-UOL-SMTP: SMTPS587
Date: Sun, 30 Jan 2011 19:38:32 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: [PATCH] ath3k: Avoid duplication of code
Message-ID: <20110130213832.GA4940@ime.usp.br>
References: <20110127232453.GA3531@ime.usp.br>
 <4D4284D7.8000200@ahsoftware.de>
 <20110128221807.GA9741@ime.usp.br>
 <4D44013B.8050306@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D44013B.8050306@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SIG5: 54f5fb9d658d58ad68ba2ef19fbbf14a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alexander.

On Jan 29 2011, Alexander Holler wrote:
> Am 28.01.2011 23:18, schrieb Rogério Brito:
> >Thanks for all the feedback on the previous patches. The one that
> >didn't compile before was sent without a hunk. This time everything
> >all the basics are verified.
> 
> They both had the same error, so I assume none of them compiled.

No, they both compiled. It was just that I messed up when generating my
patches (with git add --interactive). My git-fu is currently low, but
improving. :)

Anyway, the new version that I sent (when applied) compiles, and makes it
shorter to read the code (some could say that it more explicitly exposes
what happens in the function).


Regards,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
