Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030815Ab2CFP3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:29:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030689Ab2CFP3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:29:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v4] ARM: LPC32xx: Ethernet support
Date: Tue, 6 Mar 2012 15:29:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org
References: <1330983687-32678-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1330983687-32678-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203061529.37551.arnd@arndb.de>
X-Provags-ID: V02:K0:NUpSF3rMnBwbKHH9RVOIOgM6IDj3tlvcCd82FdRhRgZ
 bBKNXwMx3MUgkhKlPH+gNgvpGJjEZ5wAX+mlu0h8BolT26zO2M
 +jgzw37R9K2L7JEMEYgZmoRbjx2cO2n/aLsjGdvyFksmBsf5wS
 6vqB4boSju1RsEU4gNmkTfgVci9pzghbOAyDlvPSTixQEB2aeQ
 OgnZNRBGxAOsThXwa8BvNam8mLY/iwUPEk0deTYrFu40cDRhHD
 3LPlKcFUE23LtkxJaSWS2EPxyhaz3QaLRBYHCnNGkQ9GphvkVy
 vY4+2qXCQd23r9Ih90GTNstwc9laQG2I/1nsED9HtFVbZJcIce
 HtEESrFyn42UkYuU5gw0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2012, Roland Stigge wrote:
> 
> This patch adds ethernet support to the LPC32xx ARM architecture. The actual
> driver in drivers/net is contained in a separate patch.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
