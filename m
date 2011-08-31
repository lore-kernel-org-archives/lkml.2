Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1HaG2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:28:11 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62011 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1HaG2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:28:07 -0400
Date: Wed, 31 Aug 2011 14:27:43 +0800
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Dan Carpenter <error27@gmail.com>
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
Message-ID: <20110831142743.0b60148c@inspire>
In-Reply-To: <20110830140818.GL3705@shale.localdomain>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
	<1314677833-4689-9-git-send-email-leonidsbox@gmail.com>
	<20110830140818.GL3705@shale.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 17:08:19 +0300
Dan Carpenter <error27@gmail.com> wrote:

> On Tue, Aug 30, 2011 at 12:17:03PM +0800, Leonid V. Fedorenchik wrote:
> > @@ -36,13 +36,15 @@
> >   */
> >  #ifndef USE_RISC_NOOP
> >  #define MAX_BUFFER_PROGRAM_SIZE     \
> > -	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
> > +	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + \
> > +	RISC_WRITECR_INSTRUCTION_SIZE*4)
> 
> Put spaces around the operands:
> 
> +	(2 * LINES_PER_BUFFER * RISC_WRITE_INSTRUCTION_SIZE + \
> +		RISC_WRITECR_INSTRUCTION_SIZE * 4)
> 
I've missed this. Thanks.

> regards,
> dan carpenter
> 
> 



Leonid V. Fedorenchik
