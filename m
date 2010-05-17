Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0EQCKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:10:47 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51619 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0EQCKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vgPcn7gY6ZnY3phdfq48UPEsNEbCUSWSaaXOH+LZpP81or9/ldO/4eVt5W7kr4Q/+2
         7N1Vxhc6OLFhhkKzVqFLprtb4WIeckOrNQXXzc+7O0A6fahxmdsWsT26VilhrBHsXvV/
         kCsV0q12PRQ5pdDgh8cQfgM4A7gxpXBFL9USE=
Date: Mon, 17 May 2010 04:10:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu
Subject: Re: [PATCH 1/6] coda: BKL ioctl pushdown
Message-ID: <20100517021045.GD22299@nowhere>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com> <1273065339-21669-2-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273065339-21669-2-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:15:34PM +0200, John Kacur wrote:
> Convert coda_pioctl to an unlocked_ioctl pushing down the BKL into it.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---


Applied, thanks!

