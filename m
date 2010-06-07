Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0FGNhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:37:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0FGNhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:37:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Mon, 7 Jun 2010 15:37:26 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew <andrew.chih.howe.khor@intel.com>,
       Intel OTC <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <4C08D268.6000404@dsn.okisemi.com>
In-Reply-To: <4C08D268.6000404@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201006071537.27140.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/QkT3NgsuTv+j/pp31G9dNVERXk3DeosOYag0
 cxiSwC8hDkYh/Y5JHftOne7E2SinwYLz9ve/A0c0gEusLFa0vW
 0UORsDrGZekIf2cWjgmhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 June 2010, Masayuki Ohtake wrote:
> From: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> 
> This patch adds the Packet Hub driver for Topcliff.
> Patch created against 2.6.33.1
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

Most of the comments from my first review still apply to
this version, please have another look at what I wrote
back in april, see http://article.gmane.org/gmane.linux.network/158879

Note also that patch submissions should be against the latest
development kernel, in this case 2.6.35-rc2, not against stable
kernel releases like 2.6.33.1.

	Arnd
