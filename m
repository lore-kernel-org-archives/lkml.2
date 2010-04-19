Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0DSO7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:59:46 -0400
Received: from kroah.org ([198.145.64.141]:54655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab0DSO7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:59:45 -0400
Date: Mon, 19 Apr 2010 07:59:34 -0700
From: Greg KH <greg@kroah.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Kay Sievers <kay.sievers@vrfy.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: request_firmware API exhaust memory
Message-ID: <20100419145934.GA10893@kroah.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 03:20:34PM +0300, Tomas Winkler wrote:
> Lately we've been developing a device that rather more extensively
> used request_firmware API in load and also using pm_notifiers to load
> firmware.

Do you have a pointer to your driver source anywhere that shows how you
are trying to use the firmware api in this manner?

thanks,

greg k-h
