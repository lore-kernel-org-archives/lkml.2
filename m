Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1DFMdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:33:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37130 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab1DFMdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X3PJbLNqmj7IXCfz+zKRI7+2KKYeC+nYtjAsqVkktaxnbz/LJtVz7Yc8qAvSl46Vko
         rCS1L6CNkEAkkjprLKy5hjYLg2NaFvd533zCnHgXMUWZCeFSS2/Ydgx3U/hqdTIomatp
         B6tuaWJqrudzXdJAnX8XtTu4OExuAp12FZBLk=
Date: Wed, 6 Apr 2011 16:33:10 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [RFC PATCH 5/7] basic_mmio_gpio: detect output method at probe
 time
Message-ID: <20110406123310.GB17040@oksana.dev.rtsoft.ru>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
 <1302088263-12714-6-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302088263-12714-6-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:11:01PM +0100, Jamie Iles wrote:
> Rather than detecting the output method each time in the .set()
> callback, do it at probe time and set the appropriate callback.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
