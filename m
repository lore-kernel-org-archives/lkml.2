Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0HRPF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:05:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab0HRPF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:05:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] V2 2.6.35 libata support for > 512 byte sectors (e.g. 4K Native)
Date: Wed, 18 Aug 2010 17:04:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Linux IDE <linux-ide@vger.kernel.org>,
        Gwendal Grignou <gwendal@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
References: <AANLkTinx-cgn7zony8UO__zejj36GxcJTf3Pr2Z9G2af@mail.gmail.com>
In-Reply-To: <AANLkTinx-cgn7zony8UO__zejj36GxcJTf3Pr2Z9G2af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008181704.51357.arnd@arndb.de>
X-Provags-ID: V02:K0:jlRYyi/EUYv4XzlALeAp7M2fZgY8S/8+VLnGH9qQhIu
 K5rl8pnRN26BTjRLEtxU7sq/01uuZUwsHMo0CTMZXFUp6RwlxO
 +UJ3Eshk+fXQplcOYXuWg8wvmVJV+sVYEcZUhjsRb13R4RnwwU
 WH7nAXAzXRV4AFr96rDp9MGdnXZfZhY9TzUXVb+YGtSU2QSyKA
 sU7CM9LEmWaPgrVHLBYYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010, Grant Grundler wrote:
> [ patch NOT inlined because gmail will word-wrap and make a mess of
> it. Please use attached file.]

You should be able to use git-send-email with a gmail account to fix this.

	Arnd
