Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1F0TDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:03:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46941 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab1F0TBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 15:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EvwgHRjLUWGXY5KJPF+sRI4hetAzZJ7+AJzmje9amZxGNOVh9RIs8R5BViWMEmzJ1B
         SWeM+ugszQpKMRBiNFU1zWlMjdOLHrhYw3A532T9D94Rhix282v7vd+2TXWnU18+fsKB
         Li4THITw+EUPZ8g0y9MPo0Pfj+xM/7xV62PK4=
Date: Mon, 27 Jun 2011 12:00:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Mike Frysinger <vapier@gentoo.org>,
        device-drivers-devel@blackfin.uclinux.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 09/37] Remove unneeded version.h includes from
 drivers/input/
Message-ID: <20110627190001.GA13829@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1106240009201.17688@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106240009201.17688@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 12:10:37AM +0200, Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h are not needed in drivers/input/.
> This patch removes them.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks Jesper.

-- 
Dmitry
