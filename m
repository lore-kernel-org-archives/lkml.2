Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1EFGPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:15:45 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:39634 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822Ab1EFGPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:15:44 -0400
Date: Fri, 6 May 2011 08:15:27 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH 0/3] pcmcia: Make struct pcmcia_device_id const
Message-ID: <20110506061527.GA26026@comet.dominikbrodowski.net>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Jiri Kosina <trivial@kernel.org>,
	Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <cover.1304475547.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1304475547.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 07:28:59PM -0700, Joe Perches wrote:
> Reduces data use.
> 
> Staging could be applied now, but additional harmless warnings do result.
> 
> Joe Perches (3):
>   pcmcia: Make declaration and uses of struct pcmcia_device_id const
>   pcmcia: Convert pcmcia_device_id declarations to const
>   staging: pcmcia: Convert pcmcia_device_id declarations to const

Thanks, applied all three patches to the pcmcia git tree.

Best,
	Dominik
