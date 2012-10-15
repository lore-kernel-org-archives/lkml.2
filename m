Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab2JOQGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:06:13 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:33457 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2JOQGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:06:11 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during bus reset if storage interface exits
Date: Mon, 15 Oct 2012 18:04:22 +0200
Message-ID: <2156600.XT6jqS6j21@linux-lqwf.site>
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc4-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <CACVXFVM9bSX+iMx_7Z+S=HsNqNTpR0=qU3MeDQ1wD1LLM0UK-g@mail.gmail.com>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com> <1921559.OPsFBnvatA@linux-lqwf.site> <CACVXFVM9bSX+iMx_7Z+S=HsNqNTpR0=qU3MeDQ1wD1LLM0UK-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012 21:21:13 Ming Lei wrote:
> On Mon, Oct 15, 2012 at 8:30 PM, Oliver Neukum <oneukum@suse.de> wrote:
> 
> >
> > All network devices?
> 
> Good point, but I am wondering if there are guys who would like to
> bring up iSCSI over usb network dongle, which should be

LTE, UMTS. Those people may have no choice.

> very slow at least with high speed.  For super speed device,
> looks there are few network dongles in market now.
> 
> So how about keeping the limit now?

I am perfectly happy with _adding_ code only when it is needed.
Removal looks like another thing to me.
 
	Regards
		Oliver

