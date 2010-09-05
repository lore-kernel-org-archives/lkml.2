Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0IEMUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 08:20:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0IEMUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 08:20:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=pRrIDHegX5Xpo3wy76m1SCKUQ/9yCsPa+/aPIWFeDgt0cdpUXLdY0Bpu7zxsDQ4TUU
         Ewi47ZaChro/UFmyajaykXaKPlpzmArRi129BW1HpGbrzZJ7l0V0SxQ/gWRV8p5Q5R+F
         KxgxYpIXVP4sgloEpsJTGOjAHlPyFKE5UhiGk=
Date: Sun, 5 Sep 2010 14:20:31 +0200
From: Paolo Ornati <ornati@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon
 DRM KMS related - freezes
Message-ID: <20100905142031.4b692ed5@gmail.com>
In-Reply-To: <201009050953.52440.Martin@lichtvoll.de>
References: <201008312153.45792.Martin@lichtvoll.de>
	<20100901204716.775e9cfd@gmail.com>
	<201009050953.52440.Martin@lichtvoll.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Sep 2010 09:53:41 +0200
Martin Steigerwald <Martin@lichtvoll.de> wrote:

> I am also seeking help with selecting more suitable commits to test: If 
> its a Radeon KMS related freeze and everything points at it, I think the 
> offending commit is in the first quarter of what git commit shows to me[2]. 
> Thus I'd  like to select one commit before those drm/kms related commits 
> and one after it, before testing any other commits.

If you "know better" than git-bisect and want to test a particular
commit, just do:

	git reset --hard commit_id

-- 
	Paolo Ornati
	Linux 2.6.35.4 on x86_64
