Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab0HDLZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:25:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:33245 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab0HDLZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:25:31 -0400
Message-ID: <4C594E19.3040806@windriver.com>
Date: Wed, 04 Aug 2010 06:25:13 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Airlie <airlied@linux.ie>, David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 3/3] USB: drop tty argument from usb_serial_handle_sysrq_char()
References: <20100804075602.30647.91462.stgit@localhost.localdomain> <20100804075911.30647.64907.stgit@localhost.localdomain>
In-Reply-To: <20100804075911.30647.64907.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2010 11:25:15.0426 (UTC) FILETIME=[B5F26020:01CB33C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 02:59 AM, Dmitry Torokhov wrote:
> Since handle_sysrq() does not take tty as argument anymore we can
> drop it from usb_serial_handle_sysrq_char() as well.
>
>   

Acked-by: Jason Wessel <jason.wessel@windriver.com>

