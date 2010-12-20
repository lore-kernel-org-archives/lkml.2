Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab0LTUa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:30:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43729 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab0LTUaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=HXFNMbMwmB8POcJVSTjOvTyRffPapprjhoSL9C7d5ahMtFZTjAeulSs6fO6bygldoC
         GMlX2B2qtK/l3Mgz+BpWbbDzmgx621Kxcb8O+ANR6ohymY95ZDoeKVWBR56aAORN82Dt
         Hp7Ooczp9Wvpu9Gc52T/4wtFPTpR7T7hAA02M=
Date: Mon, 20 Dec 2010 23:30:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] power/gpio-charger: check for kzalloc() failure
Message-ID: <20101220203004.GB1936@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Anton Vorontsov <cbouatmailru@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20101220130856.GZ1936@bicker>
 <4D0FB6E6.2060608@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0FB6E6.2060608@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 09:04:54PM +0100, Lars-Peter Clausen wrote:
> This is now the 4th patch or so fixing this issue.

Haha.  No one can resist the easy one liners.  If I had had to kfree() a
single variable before returning then you can know for a fact I'd be too
lazy to fix it.  :P

regards,
dan carpenter

