Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2K0RWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:22:40 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab2K0RWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:22:38 -0500
Date: Tue, 27 Nov 2012 09:24:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v4] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
Message-ID: <20121127172406.GE24592@kroah.com>
References: <50B45A49.2040104@ilyx.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B45A49.2040104@ilyx.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 10:14:33AM +0400, Ilya Zykov wrote:
> Sorry. More correct.

In what way?  Should I wait for the 6th version?  :)

thanks,

greg k-h
