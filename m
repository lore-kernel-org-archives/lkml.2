Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab1DNKbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:31:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56228 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab1DNKbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:31:22 -0400
Message-ID: <4DA6CC9B.1040702@ru.mvista.com>
Date: Thu, 14 Apr 2011 14:29:47 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: storage_common: use kstrto*()
References: <c7bc1074f7cd049786ac2d50fe71b5e3ca0beba2.1302732994.git.mina86@mina86.com>
In-Reply-To: <c7bc1074f7cd049786ac2d50fe71b5e3ca0beba2.1302732994.git.mina86@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-04-2011 2:37, Michal Nazarewicz wrote:

> This commit replaces the usage of strict_strtoul() (which
> became deprecated after commit 33ee3b2e) with kstrtouint().

    Please also specify that commit's summary -- for the human readers.

> Signed-off-by: Michal Nazarewicz<mina86@mina86.com>

WBR, Sergei
