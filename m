Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1BBNZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 08:25:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44284 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1BBNZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 08:25:40 -0500
Message-ID: <4D495B0A.9070802@ru.mvista.com>
Date: Wed, 02 Feb 2011 16:24:26 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>
CC: "'Christoph Hellwig'" <hch@infradead.org>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/4] uasp: MS UAS Protocol implementation - Infrastructure
References: <1295595854-23232-1-git-send-email-tlinder@codeaurora.org> <20110121084729.GA12517@infradead.org> <003201cbc2aa$686046c0$3920d440$@org>
In-Reply-To: <003201cbc2aa$686046c0$3920d440$@org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-02-2011 10:25, Tanya Brokhman wrote:

>>> This patch implements the infrastructure for the UASP function driver.
>>> The UASP Function driver registers as a second configuration of the MS
>>> Function driver.

>> We now have a proper scsi target infrastructure in drivers/target,
>> please use it.

> Hi Christoph

> Thank you for your input. Could you please specify the exact location of the
> scsi target infrastructure you're referring to? Drivers/target is missing.

    Look at the recent kernel tree -- it's there.

> Also, if you could point me out to an example where this infrastructure is
> used or any documentation on it, it would be very helpful.

    Documentation should be in Documentation/target/?..

WBR, Sergei
