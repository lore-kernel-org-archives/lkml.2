Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab2EGToD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:44:03 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48230 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2EGToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:44:00 -0400
Message-ID: <4FA825FD.4060103@pobox.com>
Date: Mon, 07 May 2012 15:43:57 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] libata: add a host flag to ignore detected ATA devices
References: <4F903529.40800@mvista.com> <1336166111-20483-1-git-send-email-apw@canonical.com> <1336166111-20483-2-git-send-email-apw@canonical.com>
In-Reply-To: <1336166111-20483-2-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 05:15 PM, Andy Whitcroft wrote:
> Where devices are visible via more than one host we sometimes wish to
> indicate that cirtain devices should be ignored on a specific host.  Add a
> host flag indicating that this host wishes to ignore ATA specific devices.
>
> Signed-off-by: Andy Whitcroft<apw@canonical.com>

applied 1-2



