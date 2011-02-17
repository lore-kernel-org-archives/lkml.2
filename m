Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab1BQStJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:49:09 -0500
Received: from kroah.org ([198.145.64.141]:34361 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab1BQStH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:49:07 -0500
Date: Thu, 17 Feb 2011 10:42:57 -0800
From: Greg KH <greg@kroah.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] USB: ffs-test: fix header path
Message-ID: <20110217184257.GA13545@kroah.com>
References: <1297012413.2039.8.camel@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297012413.2039.8.camel@offworld>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 02:13:33PM -0300, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> When compiling this program the functionfs.h header cannot be found, producing:
> ffs-test.c:40: fatal error: linux/usb/functionfs.h: No such file or directory
> 
> This patch also fixes the following warning:
> ffs-test.c:453: warning: format ‘%4d’ expects type ‘int’, but argument 3 has type ‘size_t’
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  tools/usb/ffs-test.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

This patch doesn't apply properly to the linux-next branch, what did you
make it against?

confused,

greg k-h
