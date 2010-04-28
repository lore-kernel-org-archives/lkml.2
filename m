Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0D1MMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:12:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0D1MMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:12:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] Topcliff UART: Add the UART driver [2/2]
Date: Wed, 28 Apr 2010 14:12:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       yong.y.wang@intel.com, qi.wang@intel.com, joel.clark@intel.com,
       andrew.chih.howe.khor@intel.com
References: <001f01cae5f9$157be920$66f8800a@maildom.okisemi.com> <20100427.093307.212682271.davem@davemloft.net> <001601cae67e$2b6900d0$66f8800a@maildom.okisemi.com>
In-Reply-To: <001601cae67e$2b6900d0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004281412.38632.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX197iXWaTnJDdXRze6eTl/gOj6EQqB5i4JKLdgB
 W8On+MzKEWVRxnXFYGFlnm+ZIjEtUVKfzS6gwXsUq8m4IrZtjh
 JJ4qBSXq89yqF5P/gU70A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010, Masayuki Ohtake wrote:
> Thank you for you reporting.
> We will resubmit our patches with plain, unformatted, ASCII text.

Please also take a look at the comments from Stephen and me on the
network and packet hub drivers. Some of those also directly apply
your new Topcliff patches, so you could fix them right away before the
new submission.

In particular, see Documentation/email-clients.txt. It is unlikely
that you will be successful with your current email client.

	Arnd
