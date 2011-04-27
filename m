Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1D0Nbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:31:39 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52522 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab1D0Nbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:31:37 -0400
X-Auth-Info: OEEgO0xeVId/JgtlNo/cbeYDZmI21vg1SUJgDxXRfwY=
Message-ID: <4DB81B4C.9050404@grandegger.com>
Date: Wed, 27 Apr 2011 15:34:04 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: sachi@mistralsolutions.com, davinci-linux-open-source@linux.davincidsp.com,
        Netdev@vger.kernel.org, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>	<1303474267-6344-2-git-send-email-subhasish@mistralsolutions.com>	<4DB1A3B7.7060300@pengutronix.de> <4DB5D452.9050500@grandegger.com>	<46D523E49EFF489F9B088AE7B9CD7286@subhasishg> <4DB81A12.1000006@grandegger.com>
In-Reply-To: <4DB81A12.1000006@grandegger.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 03:28 PM, Wolfgang Grandegger wrote:
> On 04/27/2011 03:08 PM, Subhasish Ghosh wrote:
>>>
>>> - Use just *one* value per sysfs file
>>
>> SG - I felt adding entry for each mbx_id will clutter the sysfs.
>>        Is it ok to do that.
> 
> No, see:
> 
> http://lxr.linux.no/#linux+v2.6.38/Documentation/filesystems/sysfs.txt#L56

s/No/Yes/

Sorry for the confusion.

Wolfgang.
