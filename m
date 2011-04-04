Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1DDUSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:18:25 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46780 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab1DDUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:18:23 -0400
Date: Mon, 4 Apr 2011 20:42:30 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [REGRESSION] 2.6.39-rc1: f23eb2b breaks console output
Message-ID: <20110404194230.GA8785@sucs.org>
References: <BANLkTinVd8-VNM+uJ0HReA3cd6DaF-wA=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinVd8-VNM+uJ0HReA3cd6DaF-wA=A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 11:15:10PM +0400, Alexander Beregalov wrote:
> 
> commit f23eb2b2b28547fc70df82dd5049eb39bec5ba12 tty: stop using
> "delayed_work" in the tty layer
> breaks console output for me.

Same here - doing a dmesg in an xterm makes the machine hang for about
10 seconds and latencytop whinges that a raw SCSI command took 4000ms to
complete (uniprocessor x86 EeePC 900).

Additionally, you won't see this problem if you have CONFIG_PREEMPT set
but as my config has CONFIG_PREEMPT_VOLUNTARY=y I do see this problem.
Reverting f23eb2b2b28547fc70df82dd5049eb39bec5ba12 fixed the problem for
me too.

-- 
Sitsofe | http://sucs.org/~sits/
