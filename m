Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0I1LQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:16:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57244 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0I1LQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HVO06+31PZ+y869cHcqVwAeuj8f6wqqDHQ7ahzIBi4hn+ybxfRpxaOpdLhQ/8/30Ef
         ksB7K0EwRm2RfH341a8Tv7irlh4RVnH/egiGIvyODaQm+FF0zdDxGlVqSVg+HxuKmdJQ
         0dbayT+D38KR2RKd7G1itgGfd1lY8yVZwERCk=
Date: Tue, 28 Sep 2010 15:16:07 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Richard A. Smith" <richard@laptop.org>
Cc: Daniel Drake <dsd@laptop.org>, dwmw2@infradead.org, dilinger@queued.net,
        linux-kernel@vger.kernel.org, harvey.harrison@gmail.com
Subject: Re: [PATCH v2] olpc_battery: Fix endian neutral breakage for s16
 values
Message-ID: <20100928111607.GA22734@oksana.dev.rtsoft.ru>
References: <20100925181927.2C3389D401B@zog.reactivated.net>
 <4CA0AF77.1080105@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CA0AF77.1080105@laptop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:51:35AM -0400, Richard A. Smith wrote:
> On 09/25/2010 02:19 PM, Daniel Drake wrote:
> >From: Richard A. Smith<richard@laptop.org>
> >
> >When the driver was updated to be endian neutral (8e9c7716c)
> >the signed part of the s16 values was lost.  This is because be16_to_cpu()
> >returns a signed value.  This patch casts the values back to a s16 number
> >prior to the the implicit cast up to an int.
> 
> Seems the comment has a error.  Should be 'returns an unsigned'
> rather than signed.  Other than that it looks good.

Fixed and applied w/ Cc: <stable@kernel.org>, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
