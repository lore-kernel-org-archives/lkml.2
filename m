Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1ATMLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:11:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50853 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab1ATMLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:11:05 -0500
Message-ID: <4D3825FF.4030905@ru.mvista.com>
Date: Thu, 20 Jan 2011 15:09:35 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yang Ruirui <ruirui.r.yang@tieto.com>
CC: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Hao Wu <hao.wu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Alek Du <alek.du@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb langwell otg: use notifier chain of struct otg_transceiver
References: <20110120070513.GA24956@darkstar>
In-Reply-To: <20110120070513.GA24956@darkstar>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-01-2011 10:05, Yang Ruirui wrote:

> Use notifier chain in otg_transceiver instead of own notifier chain.

> This patch depends on another patch which change otg_transceiver
> notifier chain to atomic one, please see:
> https://lkml.org/lkml/2011/1/19/72

    Such comments should generally follow the --- tearline.

> Signed-off-by: Yang Ruirui<ruirui.r.yang@tieto.com>
> Reviewed-by: Felipe Balbi<balbi@ti.com>
> ---

WBR, Sergei
