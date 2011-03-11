Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1CKPMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:12:49 -0500
Received: from smtp.nokia.com ([147.243.128.24]:47286 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab1CKPMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:12:46 -0500
Message-ID: <4D7A3BD4.6030301@nokia.com>
Date: Fri, 11 Mar 2011 17:12:20 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: <andy.green@linaro.org>
CC: ext Andy Green <andy@warmcat.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <201103111331.13932.arnd@arndb.de> <4D7A191B.7040100@linaro.org> <4D7A34F1.7070601@nokia.com>
In-Reply-To: <4D7A34F1.7070601@nokia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.1.90]
X-OriginalArrivalTime: 11 Mar 2011 15:12:21.0924 (UTC) FILETIME=[B8703640:01CBDFFE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 04:42 PM, Roger Quadros wrote:

> I fail to see the problem. USB is a dynamically probed bus.
> Whether the USB peripheral is hard-wired to the board or not, it is
> still dynamically probed. The board files are not expected to know
> anything about USB peripherals prior to enumeration, so platform data
> does not make sense for USB.

sorry, my e-mail editor's line wrapping setting got messed up.

regards,
-roger
