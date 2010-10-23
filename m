Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab0JWQk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:40:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997Ab0JWQkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:40:25 -0400
Date: Sat, 23 Oct 2010 09:37:47 -0700
From: Greg KH <gregkh@suse.de>
To: Alon Ziv <alon+git@nolaviz.org>
Cc: linux-usb@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Stefani Seibold <stefani@seibold.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Export usb_serial_generic_write_room for use in
	other modules
Message-ID: <20101023163747.GA20381@suse.de>
References: <1287850818-12050-1-git-send-email-alon-git@nolaviz.org> <1287850818-12050-2-git-send-email-alon-git@nolaviz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287850818-12050-2-git-send-email-alon-git@nolaviz.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 06:20:17PM +0200, Alon Ziv wrote:
> Any module using usb_serial_generic_write (which is already exported)
> had better use usb_serial_generic_write_room as well.

Are you implying that the one driver using this function today is
broken?  Care to provide a patch for it as well?

thanks,

greg k-h
