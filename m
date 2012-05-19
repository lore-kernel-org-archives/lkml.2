Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab2ESRa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:30:26 -0400
Received: from canardo.mork.no ([148.122.252.1]:40289 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab2ESRaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:30:24 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Andrew Bird <ajb@spheresystems.co.uk>
Cc: oliver@neukum.name, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB CDC-Ether - Add ZTE WWAN matches before generic Ethernet
Organization: m
References: <1337435767-9544-1-git-send-email-ajb@spheresystems.co.uk>
Date: Sat, 19 May 2012 19:30:13 +0200
In-Reply-To: <1337435767-9544-1-git-send-email-ajb@spheresystems.co.uk>
	(Andrew Bird's message of "Sat, 19 May 2012 14:56:07 +0100")
Message-ID: <87aa14jcyi.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Bird <ajb@spheresystems.co.uk> writes:

> Some ZTE WWAN devices have generic CDC Ether descriptors. Add those
> into the whitelist so that we get FLAG_WWAN on the interface

Are you sure none of these export QMI via the CDC Ether control
interface?  Or are they not Qualcomm devices at all?

As usual, if you see a spurious "CDC: unexpected notification 01" logged
from cdc_ether, then there is reason to examine those closer.  If you
don't see any such messages, then there isn't any QMI there.


Bjørn
