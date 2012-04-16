Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2DPPcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:32:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62884 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2DPPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:32:29 -0400
Message-ID: <4F8C3B86.8000707@pobox.com>
Date: Mon, 16 Apr 2012 11:32:22 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/2] Hyper-V disk support V3
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk> <1334575229-7493-1-git-send-email-apw@canonical.com>
In-Reply-To: <1334575229-7493-1-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 07:20 AM, Andy Whitcroft wrote:
> Jeff, I believe the first patch is what you had in mind in your comments.
> Alan, the piix sadly has no subvendor/subdevice identifiers at all
> though we are able to detect the platform from the DMI information,
> this any better?

Please post "lspci -vvv" for this device...

