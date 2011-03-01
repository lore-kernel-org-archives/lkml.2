Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1CAOKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:10:53 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57870 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab1CAOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:10:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=gTcVZ0JasNdXcU/ez3Fp5L1JRYwgoNFp4F3/xImCjMhsapqLst7JbVKyt6aMGNv8ZL
         U3Z0Vef9JzxY5ODEiQE0tOMsM/r2PFLAM/M7N1xkqi0Gg/GjbRkwMJStiBDf4GPcX/Jb
         hCV/tT+Vfs0GyvWoClW3yd4XMfDWusmFEJV6w=
Date: Tue, 1 Mar 2011 22:10:30 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: joe@perches.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] MAINTAINERS: Remove unnecessary
 linux-kernel@vger.kernel.org entries
Message-ID: <20110301141024.GA9014@gmail.com>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	joe@perches.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <cover.1298439175.git.joe@perches.com>
 <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
 <20110301112038.GA12568@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301112038.GA12568@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 11:20:38AM +0000, Mark Brown wrote:
> On Tue, Feb 22, 2011 at 09:41:58PM -0800, Joe Perches wrote:
> > CC'ing lkml is the default and doesn't need separate entries.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> I've run into a noticable number of issues with users not parsing this
> convention as expected and sending only direct to maintainer mail for
> things that have no list.  For the amount of space it saves in the file
> I'm not sure it's worth removing such entries.
Hi Mark,
     I agree with Joe. I think any patch about kernel should be emailed to LKML and other connection ML, as well as maintainers.

   Thanks.
   Best Regards.
   Harry Wei.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
