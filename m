Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1AVLsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:48:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52785 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1AVLsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=stZoFl0LsoQopPjrHS7XliqSVkCQDVF3Dwb98fSI0cNG+L5ZH0dGm1G4M5VhgKeYfA
         iNBnI1I9Wu/Z0sbQWhElhVrrSoWHsCI5EehAcKnWMdxI3Nf1/fC1V7NFuF0sATtA8NSV
         KEAShmozf0trSgNJ+aG1FwOst0H+Rh43t2nGo=
Date: Sat, 22 Jan 2011 12:48:46 +0100
From: Tejun Heo <tj@kernel.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Q. block: check bdev_read_only() from blkdev_get()
Message-ID: <20110122114846.GB6160@htj.dyndns.org>
References: <23846.1295615979@jrobl>
 <20110121132802.GD2832@htj.dyndns.org>
 <5299.1295685144@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5299.1295685144@jrobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 22, 2011 at 05:32:24PM +0900, J. R. Okajima wrote:
> It must be faster and sure that you (or other bdev people) would fix
> much more than I do.
> I don't think you want me to dive into unfamiliar code.

As you already have figured out most of technical details, I don't
think it would have been difficult, and, hey, jumping into unfamiliar
code is half of the fun when working on the kernel.  Anyways, if you
aren't interested, I'll give it a shot.

Thanks.

-- 
tejun
