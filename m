Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab2EJJwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:52:07 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4580 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758290Ab2EJJwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:52:05 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4FAB8FB3.906@broadcom.com>
Date: Thu, 10 May 2012 11:51:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Ben Minerds" <puzzleduck@gmail.com>
cc: alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        richard.weinberger@gmail.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/21] USB: serial: Changes to conform with
 checkpatch.sh script.
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
X-Enigmail-Version: 1.5pre
X-WSS-ID: 63B550423E031038810-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 11:17 AM, Ben Minerds wrote:
> Hi all,
>    Patch series for drivers/usb/serial/keyspan.c to remove warnings and errors running checkpatch.sh
>    Order should not be critical. 

I guess there is a rule is to have small patches to accommodate
reviewing, but this series seems silly. Especially with all those
duplicate subject lines and it is touching only one file.

Gr. AvS

