Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab1KSG31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 01:29:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab1KSG30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 01:29:26 -0500
Date: Sat, 19 Nov 2011 14:28:56 +0800
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] Staging: cx25821: Clean up patch series
Message-ID: <20111119142856.3c619022@inspire>
In-Reply-To: <4EA3A7ED.8090404@redhat.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
	<20111022081941.GA5443@suse.de>
	<4EA3A7ED.8090404@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Oct 2011 07:36:45 +0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em 22-10-2011 10:19, Greg KH escreveu:
> > On Sat, Oct 22, 2011 at 01:43:20PM +0800, Leonid V. Fedorenchik wrote:
> >> This patch series fixes some style issues in drivers/staging/cx25821
> >> Mostly I was hoping to improve readability and fix some issues found by
> >> checkpatch.pl script.
> > 
> > These are for Mauro to take through his tree.
> 
> Yes. I'll put them on my queue.

I didn't find this patch series in any of linux, staging, linux-media,
and media-next trees. Since you moved driver cx25821 out of staging,
do you want me to resend this patch series rebased on top of media-next?

Or I missed it somewhere and you applied it?

> 
> Thanks,
> Mauro

Thanks,
Leonid V. Fedorenchik
