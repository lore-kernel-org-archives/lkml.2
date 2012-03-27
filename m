Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2C0Vts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:49:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39265 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2C0Vtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:49:46 -0400
Date: Tue, 27 Mar 2012 14:49:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/2] firmware_class: Reorganize fw_create_instance()
Message-ID: <20120327214941.GA21812@kroah.com>
References: <201203260000.34377.rjw@sisk.pl>
 <1332883710-7486-1-git-send-email-sboyd@codeaurora.org>
 <201203272347.06621.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203272347.06621.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 11:47:06PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, March 27, 2012, Stephen Boyd wrote:
> > Recent patches to split up the three phases of request_firmware()
> > lead to a casting away of const in fw_create_instance(). We can
> > avoid this cast by splitting up fw_create_instance() a bit.
> > 
> > Make _request_firmware_setup() return a struct fw_priv and use
> > that struct instead of passing struct firmware to
> > _request_firmware(). Move the uevent and device file creation
> > bits to the loading phase and rename the function to
> > _request_firmware_load() to better reflect its purpose.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Looks good to me.
> 
> Greg, if that's fine with you, I'll add this patch (and the next one)
> to my firmware_class series you've looked at recently.

Yes, it's fine with me:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

