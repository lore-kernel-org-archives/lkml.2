Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1CFMLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:11:45 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:40859 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1CFMLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:11:43 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Mar 2011 07:11:43 EST
From: Oliver Neukum <oliver@neukum.org>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH] [media] dib0700: get rid of on-stack dma buffers
Date: Sun, 6 Mar 2011 13:06:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <1299410212-24897-1-git-send-email-florian@mickler.org>
In-Reply-To: <1299410212-24897-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103061306.10045.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 6. März 2011, 12:16:52 schrieb Florian Mickler:
> This should fix warnings seen by some:
> 	WARNING: at lib/dma-debug.c:866 check_for_stack
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=15977.
> Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Signed-off-by: Florian Mickler <florian@mickler.org>
> CC: Mauro Carvalho Chehab <mchehab@infradead.org>
> CC: linux-media@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: Greg Kroah-Hartman <greg@kroah.com>
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Maciej Rutecki <maciej.rutecki@gmail.com>
> ---
> 
> Please take a look at it, as I do not do that much kernel hacking
> and don't wanna brake anybodys computer... :)
> 
> From my point of view this should _not_ go to stable even though it would
> be applicable. But if someone feels strongly about that and can
> take responsibility for that change...

The patch looks good and is needed in stable.
It could be improved by using a buffer allocated once in the places
you hold a mutex anyway.

	Regards
		Oliver
