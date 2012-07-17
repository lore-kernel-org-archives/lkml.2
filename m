Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2GQMld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:41:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab2GQMlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:41:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next] mei: use module_pci_driver
Date: Tue, 17 Jul 2012 12:41:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <1342513427-10076-1-git-send-email-tomas.winkler@intel.com> <1342513427-10076-2-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1342513427-10076-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207171241.20930.arnd@arndb.de>
X-Provags-ID: V02:K0:ZXcrusFLnVPvVI2JS1+/hNLasdHOwmJrCeZ5cFN+F06
 SCGkr+cpEuJXG6V1//Jtu64Wn7Mz9N88gqeQfOQhlVM17LD4cA
 xWJl7IU+tB+lFfc87qSqYZRCPD6MZn7WmDS4bldm1j5bKQkHi2
 SAG3F0MraIdobAJ2t3PXeKq/lciYILlRIMbdCHxed3PZXiZPEF
 yXp92WGh01jG+VSYEr+MJ/6478yvjLKTwFVI/E9vCVm3DXT2fU
 QarfeC6ee0YCl6WzYjwkN4D2dYSG1SIWjvBzqE20L8z03Opz9m
 gx4quyflCbXsYbezFLipU7OO40B5CvfqLQv1jdLZ2M3x8Z6LwK
 R0LrBDcKC1NpPriGuZB4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012, Tomas Winkler wrote:
> 
> Change-Id: I960feed4157ad1b178f68f4a0b3968e185ed0b36

The change log got mangled. Please make sure the text you have here actually
describes what the patch does and why.

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/main.c |   39 +--------------------------------------
>  1 files changed, 1 insertions(+), 38 deletions(-)
For the actual changes:

Acked-by: Arnd Bergmann <arnd@arndb.de>
