Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0DSQCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:02:54 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:57666 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab0DSQCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:02:52 -0400
Date: Mon, 19 Apr 2010 16:56:31 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: wim@iguana.be, alan@redhat.com, andy.sharp@onstor.com,
       linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH/RESEND] MIPS: Fix sibyte watchdog initialization
Message-ID: <20100419155631.GA18697@linux-mips.org>
References: <1271691431-28166-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271691431-28166-1-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 08:37:11AM -0700, Guenter Roeck wrote:

> Watchdog configuration register and timer count register were interchanged,
> causing wrong values to be written into both registers.
> This caused watchdog triggered resets even if the watchdog was reset in time.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> Resend:
>     Widening the audience.
>     Please let me know if there are any problems with this patch.

For the new audience, this patch has been previously posted to linux-mips
a few days ago and assuming there are no objections I'd like to merge it
upstream for 2.6.34, so an Ack would by nice.

  Ralf
