Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0L3NEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 08:04:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0L3NEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 08:04:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] spufs: use simple_write_to_buffer
Date: Thu, 30 Dec 2010 14:04:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jeremy Kerr <jk@ozlabs.org>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org
References: <n> <1293257039-2580-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1293257039-2580-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301404.27090.arnd@arndb.de>
X-Provags-ID: V02:K0:t0ejBYbUA4oTqMJO4QQUt/3UoNowsgymugrSIOUW+4V
 v59aKGveSnT1FOcCjN+0mZyEr2JypSbq6hz6H9PFtXe0KXVC5A
 LJntjcez0yAPIuvFCyoQbgvL4SiO2ZJPYY4QLYuI6CpvIgfqax
 r1mA0jldjk7IxAOF1xNzfJ0wZd9zSy+bJmM9IDlIPz4dg72Z8Z
 dtm+gbkUWKXlE2bMGtj6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 December 2010, Akinobu Mita wrote:
> Simplify several write fileoperations for spufs by using
> simple_write_to_buffer().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Jeremy Kerr <jk@ozlabs.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: cbe-oss-dev@lists.ozlabs.org

Looks good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
