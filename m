Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1IGQTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:19:00 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:59714 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab1IGQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:18:59 -0400
Message-ID: <4E678688.8090204@stericsson.com>
Date: Wed, 7 Sep 2011 16:58:16 +0200
From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCHv4 04/19] usb: otg: ab8500: Start using struct usb_otg
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>  <1315379772-8830-5-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1315379772-8830-5-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/07/2011 09:15 AM, Heikki Krogerus wrote:
> Use struct usb_otg members with OTG specific functions instead
> of usb_phy members.
>
> Signed-off-by: Heikki Krogerus<heikki.krogerus@linux.intel.com>
> Cc: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>
>    

Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>


Thanks,

-- 
Mian Yousaf Kaukab

