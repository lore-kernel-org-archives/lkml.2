Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0JRKPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:15:36 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:47393 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab0JRKPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:15:35 -0400
Date: Mon, 18 Oct 2010 11:15:31 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix build failure on asm/fcntl.h
Message-ID: <20101018101531.GD27377@linux-mips.org>
References: <1287333699-1254-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287333699-1254-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 01:41:39AM +0900, Namhyung Kim wrote:

>   CC      security/integrity/ima/ima_fs.o
> In file included from linux/include/linux/fcntl.h:4:0,
>                  from linux/security/integrity/ima/ima_fs.c:18:
> linux/arch/mips/include/asm/fcntl.h:63:2: error: expected specifier-qualifier-list before 'off_t'
> make[3]: *** [security/integrity/ima/ima_fs.o] Error 1
> make[2]: *** [security/integrity/ima/ima_fs.o] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, applied.

  Ralf
