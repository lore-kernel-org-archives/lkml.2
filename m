Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1CCLvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:51:48 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48289 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab1CCLvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:51:47 -0500
X-Sasl-enc: tgWqz0/JjR/8c3o3pyeXKNxx6vbNQgrGALDmyIJSihkz 1299153106
Message-ID: <4D6F80D2.2000005@fastmail.fm>
Date: Thu, 03 Mar 2011 11:51:46 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.14) Gecko/20110221 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jonathan_Neusch=E4fer?= <j.neuschaefer@gmx.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: keucr: use kernel byteorder functions
References: <20110303113225.GA1341@debian.debian> <1299152300-5585-1-git-send-email-j.neuschaefer@gmx.net>
In-Reply-To: <1299152300-5585-1-git-send-email-j.neuschaefer@gmx.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 11:38, Jonathan Neuschäfer wrote:
> ---
>  drivers/staging/keucr/TODO     |    1 -
>  drivers/staging/keucr/common.h |   12 ------------
>  drivers/staging/keucr/ms.c     |   28 +++++++++++++++-------------
>  3 files changed, 15 insertions(+), 26 deletions(-)

You'll need at least a Signed-off-by and possibly a brief changelog

Pending that

Reviewed-by: Jack Stone <jwjstone@fastmail.fm>

Thanks,

Jack
