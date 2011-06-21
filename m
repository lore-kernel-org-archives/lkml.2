Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1FUJUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:20:19 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:49409 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754261Ab1FUJUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:20:15 -0400
Date: Tue, 21 Jun 2011 09:57:00 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Ram Pai <linuxram@us.ibm.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, svenkatr@ti.com, yinghai@kernel.org,
        cjb@laptop.org, linux-pci@vger.kernel.org,
        linux-net-drivers@solarflare.com, bhutchings@solarflare.com
Subject: Re: [PATCH 4/4] PCI: make cardbus-bridge resources nice-to-have
Message-ID: <20110621075659.GA4620@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Ram Pai <linuxram@us.ibm.com>, jbarnes@virtuousgeek.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	svenkatr@ti.com, yinghai@kernel.org, cjb@laptop.org,
	linux-pci@vger.kernel.org, linux-net-drivers@solarflare.com,
	bhutchings@solarflare.com
References: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
 <1308610037-6261-5-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308610037-6261-5-git-send-email-linuxram@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 03:47:17PM -0700, Ram Pai wrote:
> Allocate resources to cardbus bridge only after all other genuine
> resources requests are satisfied. Dont retry if resource allocation
> for cardbus-bridge fails.

Well, for those who use cardbus cards, cardbus resources aren't "nice to
have", they are absolutely required. Of course, not all cardbus cards need
as many resources as are currently assigned, so I wouldn't oppose a patch
which marks _some_ of the currently assigned resources as "nice to have".
But this approach -- 0 required, all "nice to have" -- seems wrong to me.

Best,
	Dominik
