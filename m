Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1H3OKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:10:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46551 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3OKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:10:49 -0400
Date: Tue, 30 Aug 2011 17:08:19 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Youquan Song <youquan.song@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>, devel@linuxdriverproject.org,
        Joe Perches <joe@perches.com>, Ilya Gorskin <Revent82@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: [PATCH v3 08/18] Staging: cx25821: Fix too long lines in
 cx25821-audio.h
Message-ID: <20110830140818.GL3705@shale.localdomain>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
 <1314677833-4689-9-git-send-email-leonidsbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314677833-4689-9-git-send-email-leonidsbox@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 12:17:03PM +0800, Leonid V. Fedorenchik wrote:
> @@ -36,13 +36,15 @@
>   */
>  #ifndef USE_RISC_NOOP
>  #define MAX_BUFFER_PROGRAM_SIZE     \
> -	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
> +	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + \
> +	RISC_WRITECR_INSTRUCTION_SIZE*4)

Put spaces around the operands:

+	(2 * LINES_PER_BUFFER * RISC_WRITE_INSTRUCTION_SIZE + \
+		RISC_WRITECR_INSTRUCTION_SIZE * 4)

regards,
dan carpenter


