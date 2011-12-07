Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1LGLrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:47:03 -0500
Received: from bitmer.com ([213.157.87.50]:51607 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab1LGLrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:47:01 -0500
Message-ID: <4EDF5231.6080309@bitmer.com>
Date: Wed, 07 Dec 2011 13:46:57 +0200
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>	<1323105820-25946-3-git-send-email-felipe.contreras@nokia.com> <CAMP44s3Szzm9iXxghXfNCBjKyUw-nRrG1aEeweKnRCidaxmxEA@mail.gmail.com>
In-Reply-To: <CAMP44s3Szzm9iXxghXfNCBjKyUw-nRrG1aEeweKnRCidaxmxEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 07:31 PM, Felipe Contreras wrote:
> Should probably have CC'ed linux-omap.
>
> On Mon, Dec 5, 2011 at 7:23 PM, Felipe Contreras
> <felipe.contreras@nokia.com>  wrote:
>> From: Felipe Contreras<felipe.contreras@gmail.com>
>>
>> This reverts commit 10299e2e4e3ed3b16503d4e04edd48b33083f4e2.
>>
>> This seems to break USB networking stuff.
>>
I don't think revert is needed since CONFIG_CHARGER_ISP1704=y should 
make it working. Although I don't know do we really need to drive the 
ISP1704 into reset in board-rx51-peripherals.c? Would it be better to 
leave gpio state as it was set by the bootloader and let the driver to 
do reset sequence if needed?

http://marc.info/?l=linux-omap&m=130795363204884&w=2

-- 
Jarkko
