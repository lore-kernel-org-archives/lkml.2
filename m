Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2ELM4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 08:56:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab2ELM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 08:56:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] gpiolib: Use seq_file's iterator interface
Date: Sat, 12 May 2012 12:56:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1334229961-1844-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1334229961-1844-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205121256.14283.arnd@arndb.de>
X-Provags-ID: V02:K0:Soljqxchkhh97ElZutqz5xgpxbRWL8xWea8/hB9QOlb
 8V/NOzbbvRjJpjmT65jdFZayaIUeEgVAHx+/PoiJuifb4UJvZx
 4rnEcnqk0KvTYJmNZXh6k4ghs3KAbJwu7Lv/9GH/qHLTe/6v6d
 h5nmT7e1CNINik5ZX4wlOTkkE9lG5lnRPJ/5QDrIPFk4TKRBmk
 MP0394s6H38q6COQjX1czZGkYgIhTzS6w0i6/gdS1GNYJi15RZ
 UmZlsO7LPs1p8MfyQM6IMfJXagtawTBTx6yKdFr1ankdkNiOh5
 4j/k1+jLqTehvaubcyj6kAuCjTDGWHHQbZMsF0pi7nwBUMdSkN
 Z5V/vIAqbB2w7fiW16R4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2012, Thierry Reding wrote:
> When dumping a collection of items via seq_file, it is recommended to
> use the iterator interface. For the gpiolib debugfs interface this can
> be done to dump each GPIO chip in turn.
> 
> Note that for gpiolib this is a little cumbersome because it does not
> provide a list of registered GPIO chips and the only way to iterate is
> over each GPIO individually. Once a chip is found, the number of GPIOs
> it provides can be skipped as a small optimization.
> 
> This patch was requested by Arnd Bergmann here:
> 
>         http://article.gmane.org/gmane.linux.ports.tegra/3535
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-kernel@vger.kernel.org

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
