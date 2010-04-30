Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0D3Rfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:35:53 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:42850 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab0D3Rfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:35:39 -0400
X-Greylist: delayed 1831 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 13:35:39 EDT
MIME-Version: 1.0
In-Reply-To: <4BDB12FB.5060806@in.ibm.com>
References: <4BDAF376.4030005@in.ibm.com> <4BDB12FB.5060806@in.ibm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 30 Apr 2010 11:35:13 -0600
X-Google-Sender-Auth: 6315612b62129fd1
Message-ID: <n2kfa686aa41004301035p7e15c017u7a1b98389cc1e466@mail.gmail.com>
Subject: Re: -next Apr 30: OOPS during eHEA driver initialization
To: Sachin Sant <sachinp@in.ibm.com>
Cc: "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 11:27 AM, Sachin Sant <sachinp@in.ibm.com> wrote:
> Sachin Sant wrote:
>>
>> With today's next eHEA drivers fails to initialize.
>
> If i revert the following patch eHEA network interface is initialized
> properly.
>
> commit cebfe0b6709abdab997c1a00499d67efa32ee1f0
> drivercore: Add of_match_table to the common device drivers

That is an easy one to fix.  I'll get it updated today and send you the result.

g.
