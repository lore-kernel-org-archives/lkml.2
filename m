Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0C3Q4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:56:49 -0400
Received: from mail.atheros.com ([12.36.123.2]:30493 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab0C3Q4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:56:47 -0400
Date: Tue, 30 Mar 2010 09:56:45 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis de Bethencourt <luisbg@ubuntu.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath: fix code readability in regd.c
Message-ID: <20100330165645.GB25095@tux>
References: <ath/regd.c>
 <1269963873-2070-1-git-send-email-luisbg@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1269963873-2070-1-git-send-email-luisbg@ubuntu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 08:44:33AM -0700, Luis de Bethencourt wrote:
> This is a patch to the ath/regd.c file that fixes two code
> readability issues. A space between to separate two defines
> and the indentation inside the ath_redg_is_eeprom_valid
> function.

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

You can drop netdev and linux-kernel from future linux-wireless e-mails
like this one.

  Luis
