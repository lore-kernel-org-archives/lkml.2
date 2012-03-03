Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab2CCMxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 07:53:08 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2561 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab2CCMxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 07:53:06 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4F52141C.2050808@broadcom.com>
Date: Sat, 3 Mar 2012 13:52:44 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] compat: makes all compat symbols
 EXPORT_SYMBOL_GPL()
References: <1330729706-11113-1-git-send-email-mcgrof@frijolero.org>
In-Reply-To: <1330729706-11113-1-git-send-email-mcgrof@frijolero.org>
X-WSS-ID: 634CC9B361S667892-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2012 12:08 AM, Luis R. Rodriguez wrote:
> The Linux kernel is being backported here and a lot of code
> is completely derivative works of the the Linux kernel, as such
> only GPL-Compatible modules are intended to be used with this
> framework, given that users of this framework are considered
> completely derivative works of the Linux kernel.
>
> Only upstream Linux kernel modules or kernel modules on their
> way upstream are intended to be used by this.
> Tested with ckmake:

Hi Luis,

Some of the modules in this patch are dual-licensed. I was under the 
impression that EXPORT_SYMBOL_GPL was specifically for GPL-only code 
although I could not find any specifics in the Documentation folder. Do 
you (or someone else) have a reference on this topic?

Gr. AvS

