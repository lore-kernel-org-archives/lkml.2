Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab2JXScX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:32:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33316 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030208Ab2JXScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:32:20 -0400
Date: Wed, 24 Oct 2012 11:32:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vineet.Gupta1@synopsys.com
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] serial/arc-uart: Add new driver
Message-ID: <20121024183217.GA18389@kroah.com>
References: <1349336152-30443-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349336152-30443-1-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 01:05:52PM +0530, Vineet.Gupta1@synopsys.com wrote:
> From: Vineet Gupta <vgupta@synopsys.com>
> 
> Driver for non-standard on-chip UART, instantiated in the ARC (Synopsys)
> FPGA Boards such as ARCAngel4/ML50x

This patch does not apply against my tty-next tree, care to rebase it
and resend it so that I can apply it?

thanks,

greg k-h
