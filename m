Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0ISNXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 09:23:25 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:57468 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753712Ab0ISNXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 09:23:24 -0400
Date: Sun, 19 Sep 2010 15:23:20 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] pcmcia: cs: fix device_register() error handling
Message-ID: <20100919132320.GB5569@isilmar-3.linta.de>
Mail-Followup-To: Vasiliy Kulikov <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1284900895-24453-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284900895-24453-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 04:54:55PM +0400, Vasiliy Kulikov wrote:
> If device_register() fails then call put_device().
> See comment to device_register.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks,
	Dominik
