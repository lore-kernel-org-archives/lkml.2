Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2GaNJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:09:46 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63325 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2GaNJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:09:42 -0400
Message-ID: <5017D911.3010101@windriver.com>
Date: Tue, 31 Jul 2012 08:09:37 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Colin Ian King <colin.king@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: echi-dbgp: increase the controller wait time to
 come out of halt.
References: <1343660802-10391-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1343660802-10391-1-git-send-email-colin.king@canonical.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 10:06 AM, Colin Ian King wrote:
> The default 10 microsecond delay for the controller to come out of
> halt in dbgp_ehci_startup is too short, so increase it to 1 millisecond.
>
> This is based on emperical testing on various USB debug ports on
> modern machines such as a Lenovo X220i and an Ivybridge development
> platform that needed to wait ~450-950 microseconds.

This seems fine to me.

I'll test it, merge it, and add a CC for -stable.

Thanks,
Jason.
