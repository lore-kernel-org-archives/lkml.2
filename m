Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0EaIey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:34:54 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:59446 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0EaIex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:34:53 -0400
Date: Mon, 31 May 2010 10:33:58 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       linux-cris-kernel <linux-cris-kernel@axis.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andy Whitcroft <apw@canonical.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH] ioctl for getting RS485 information on Cris
	architecture
Message-ID: <20100531083358.GH5051@axis.com>
References: <49A51878.7020206@evidence.eu.com> <4C0370FD.3090909@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0370FD.3090909@evidence.eu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:19:09AM +0200, Claudio Scordino wrote:
> Hi Jesper, hi Mikael, 
> 
> 	I think that the Cris architecture should provide a full RS485 interface (like the atmel_serial driver).
> 
> Therefore, I propose this patch which adds an ioctl to get RS485 information from user-level.

Thanks, looks good, I'll take this into the CRIS tree.

>              Claudio

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
