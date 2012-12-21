Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2LUTni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 14:43:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2LUTnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 14:43:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [PATCH 1/2] asm-generic: uaccess: allow arch to over-ride __get_user_fn()
Date: Fri, 21 Dec 2012 19:43:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1353422297-29079-1-git-send-email-vgupta@synopsys.com> <1353422297-29079-2-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1353422297-29079-2-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212211943.32199.arnd@arndb.de>
X-Provags-ID: V02:K0:+fKXfambO7k55vU7LAPBapIcyblPYBOkxl+acbRsLCe
 Qu0My8Xg+eBz51TiEdfGJR1ZS/piqsK/kAV33JZ6sFeYASh7AJ
 fMPmpIfxULcTZVbiQGcnzBOh36ctcLcNoxLXdxbUqjiksl/b2N
 +k92hFcTAu6xsHbXJCr6XFXFgDrgj6bdpPaKYiLznaK6TPMtcG
 Z3NXtA2c95kXrBPfk0HuT+GD2W8FIFbczmdOAZrzU3y5bkErs0
 hXNVQ9Q7SFkVFkeXBRudbQY04kDgolD2tJ21UWeqKOoDSfPiUV
 prT6lDgKsjBK7gzele8z0sZvQYxynkFQM9a1F5LEIoM0wdj0ht
 Y7+B/D7a2k4grJJmXh4Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012, Vineet.Gupta1@synopsys.com wrote:
> From: Vineet Gupta <vgupta@synopsys.com>
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
