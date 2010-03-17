Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0CQLxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:53:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36915 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0CQLxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:53:06 -0400
Date: Wed, 17 Mar 2010 11:53:03 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch false positive
Message-ID: <20100317115303.GO5443@shadowen.org>
References: <1268823629.1999.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268823629.1999.9.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 11:00:29AM +0000, Richard Kennedy wrote:
> I'm getting this error from checkpatch which is a false positive AFAICT.
> I don't see any other way to code this macro so maybe this rule
> shouldn't apply?.
> 
> 	ERROR: space prohibited before open square bracket '['
> 	#24: FILE: drivers/staging/wlan-ng/p80211wext.c:1685:
> 	+#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]

Yes that is definatly false, feed free to ignore it.  I'll have a look
at fixing it.

-apw
