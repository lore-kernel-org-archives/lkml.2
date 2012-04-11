Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894Ab2DKS3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:29:00 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:56076 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2DKS27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:28:59 -0400
Date: Wed, 11 Apr 2012 20:28:56 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Ted Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        hjl.tools@gmail.com
Subject: Re: Trying to make a working kernel with the gold linker
Message-ID: <20120411182856.GA327@x4>
References: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
 <20120411045107.GA324@x4>
 <20120411180520.GE12044@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411180520.GE12044@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.04.11 at 14:05 -0400, Ted Ts'o wrote:
> On Wed, Apr 11, 2012 at 06:51:07AM +0200, Markus Trippelsdorf wrote:
> > 
> > Yes. I use it regularly. The last problems were fixed two years ago.
> > Please try a more recent version.
> 
> Thanks, I'll give that a try.  Next stupid question; for a variety of
> reasons, the Corporate I/T folks require that I stay stuck on Ubuntu
> 10.04.  Are there any incompatibility problems with using the most
> recently released binutils-gold and gcc 4.4.3-4ubuntu5.1?  Basically,
> can I just compile a new version of binutils, or do I need to upgrade
> my entire compiler toolchain?

Just compiling and installing a new binutils version should work fine.

(But you should nonetheless consider to also upgrade gcc, because
gcc-4.4 is ancient and not even officially maintained anymore...)

-- 
Markus
