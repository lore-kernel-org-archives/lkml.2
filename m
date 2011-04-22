Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1DVPFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:05:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43275 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1DVPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KthNN6eYkNLKaBgW5s+a3e6Okk3Pd3efe4+zDLMljF76mMwZGcvlW3mClYC5LyNanF
         i7vYnTu9AFNU51jjEZSVYPtWzRP3ZrMJSY3ECB4T1ULGlvwyARxsSqPCHuFpzJpfgmLI
         jmRDOBlRxnTDUV/CpmL5khXaqxGnAVDw9FHvY=
Date: Fri, 22 Apr 2011 17:03:06 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Tomas Carnecky <tom@dbservice.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression caused by 8969960 (mm: vmap area cache)
Message-ID: <20110422150306.GA3036@joi.lan>
References: <4DB09A38.5000902@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB09A38.5000902@dbservice.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 10:57:28PM +0200, Tomas Carnecky wrote:
> My intel atom mini-itx board doesn't boot anymore after said commit. The 
> last messages I see in the console indicate that the kernel has just 
> switched to the nouveau fb driver. Reverting the commit on top of the 
> latest master does not seem to help.
> 

This is a bug in nouveau and it's already fixed in Linus' tree
(commit a18d89ca026140eb8ac4459bf70a01c571dd9a32 "drm/nouveau: fix notifier
memory corruption bug"). The fix will soon be applied to .38-stable.

Marcin

