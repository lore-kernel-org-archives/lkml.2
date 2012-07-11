Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab2GKIha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:37:30 -0400
Received: from canardo.mork.no ([148.122.252.1]:56294 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab2GKIh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:37:27 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "open list\:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB_VENDOR_AND_INTERFACE_INFO() macro
Organization: m
References: <1341957063-11989-1-git-send-email-gustavo@padovan.org>
	<20120710220108.GA28387@kroah.com>
Date: Wed, 11 Jul 2012 10:36:46 +0200
In-Reply-To: <20120710220108.GA28387@kroah.com> (Greg Kroah-Hartman's message
	of "Tue, 10 Jul 2012 15:01:08 -0700")
Message-ID: <877guahext.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Tue, Jul 10, 2012 at 06:51:03PM -0300, Gustavo Padovan wrote:
>
>> { USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) }
>
> Two entries in the cdc_wdm driver can also be converted to use this
> interface.  Do you want to send a patch doing that, or do you want me to
> do it?

Only if you decide to take this change in 3.4 and 3.5.  Those entries
are gone in 3.6.



Bjørn
