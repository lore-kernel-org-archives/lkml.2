Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2KPRFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:05:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35037 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2KPRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:05:41 -0500
Date: Fri, 16 Nov 2012 09:05:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: pe1dnn@amsat.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: wlags49_h2: ap_h2: fixes coding style issues
Message-ID: <20121116170537.GA30626@kroah.com>
References: <1353084759-8792-1-git-send-email-johanmeiring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353084759-8792-1-git-send-email-johanmeiring@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:52:39PM +0200, Johan Meiring wrote:
> This corrects several instances of spaces before tabs and incorrect spacing around "*" characters.  It also fixes some 80+ character line length issues, but the majority of such cases have been left as is, as this was probably the author's intention.

Please wrap your changelog lines at the properly length (i.e. 72
columns)

Also, please only do one thing per patch.  You are doing multiple things
here, which makes it hard to review.

Same goes for the other patches in this series, please break it up into
smaller steps, which makes for more patches, but it makes it easier to
review to ensure you didn't do something wrong.

Care to redo this and resend it?

thanks,

greg k-h
