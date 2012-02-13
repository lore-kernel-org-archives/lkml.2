Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2BMVkC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:40:02 -0500
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:43832
	"EHLO l.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2BMVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:40:01 -0500
Message-ID: <4F398303.1030606@chelsio.com>
Date: Mon, 13 Feb 2012 13:39:15 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>, nhorman@tuxdriver.com
Subject: Re: [patch net-next] cxgb3: update firmware version
References: <20120213202846.631.30806.stgit@speedy5.asicdesigners.com> <1329165817.2092.62.camel@shinybook.infradead.org>
In-Reply-To: <1329165817.2092.62.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 13, 2012 12:43:37 PM, David Woodhouse wrote:
>
> On Mon, 2012-02-13 at 12:28 -0800, Divy Le Ray wrote:
>>
>> This patch updates the firmware version cxgb3 is requesting to 7.12.0.
>
>
> I'm confused. Your patch doesn't change anything in the driver, except
> the firmware version. So why is it a "major" change?

Hi David,

cxgb3 embeds the firmware file name it will request at load time.
It uses the FW_VERSION_* defs to construct the firmware name FW_FNAME 
before calling request_firmware().
Hence the need to update the firmware minor version.

On the other hand, the driver version update is not a strict requirement 
here.
I would prefer keeping it though.

Cheers,
Divy

