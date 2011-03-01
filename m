Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab1CAXWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:22:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab1CAXWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=EKjpuaekbyCtqBNbqwqjasm9yv77rcdJ5O1DJzNabO1LrB91pbTbz9LKRPxJCR85a2
         b5HvhwG4CIHVwO4mkvatte4z4EeeayZC7O6faJsHsYSDTxCOlTUJLqhm8EriNJ/rgrE6
         zkdRL8KD+Pd/wnf5K+0dELnoQbd0SBDC+LZF0=
Date: Wed, 2 Mar 2011 02:22:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Angelo Arrifano <miknix@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: quickstart: remove trailing whitespace
Message-ID: <20110301232234.GA18043@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
	Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
	Angelo Arrifano <miknix@gmail.com>, linux-kernel@vger.kernel.org
References: <1299021017-11918-1-git-send-email-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299021017-11918-1-git-send-email-j.neuschaefer@gmx.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 12:10:16AM +0100, Jonathan Neuschäfer wrote:
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---

Someone already fixed this in a different patch.

Generally these things aren't worth fixing on their own.  No one 
will even notice the whitespace unless they're looking for it.

regards,
dan carpenter

