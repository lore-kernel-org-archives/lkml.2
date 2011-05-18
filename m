Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1ERP0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:26:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59753 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab1ERP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:26:17 -0400
X-Sasl-enc: dj4zWP3nrX6xAUP2YYlsxFYn3Ernw3H/QWloMS0qVkpK 1305732376
Date: Wed, 18 May 2011 08:24:28 -0700
From: Greg KH <greg@kroah.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Olaf Hartmann <o.hartmann@telovital.com>
Subject: Re: [RFC/RFT PATCH] Staging: et131x: add suspend/resume support
Message-ID: <20110518152428.GA8106@kroah.com>
References: <1305724667-2980-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305724667-2980-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:17:47AM -0300, Herton Ronaldo Krzesinski wrote:
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

I think we need a bit more comments here.

Like have you tested this to verify that it works?  Anything else?

thanks,

greg k-h
