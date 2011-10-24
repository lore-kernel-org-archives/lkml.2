Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1JXM3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:29:07 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:35002
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932216Ab1JXM3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:29:06 -0400
Message-ID: <4EA55A08.5090509@compulab.co.il>
Date: Mon, 24 Oct 2011 14:28:56 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCHv5 13/19] usb: otg: ulpi: Start using struct usb_otg
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com> <1317036092-3000-14-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1317036092-3000-14-git-send-email-heikki.krogerus@linux.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 02:21 PM, Heikki Krogerus wrote:
> Use struct usb_otg members with OTG specific functions instead
> of usb_phy members.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---

Acked-by: Igor Grinberg <grinberg@compulab.co.il>
