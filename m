Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab1DGXlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:41:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53012 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1DGXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oH0P8xaeaMLJLf5a8sM0qQ4z+l9tSDF6ipjBFVoGa0oNtm+cFS/g++JJUJm1a4cTpV
         z7MoEu9lH6AwsPP7+OsuREhnhnMG1+yuDDT/YtrvBqgrz8U79AauAVgttTR+rEDH5pfH
         25D133BpCRsVKNtmaqg9PEKCZygXqG0cN3nps=
Message-ID: <4D9E4B86.1030102@gmail.com>
Date: Thu, 07 Apr 2011 16:40:54 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        trivial@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC 1/5]arch/arm/common/Makefile Remove unused config in the
 Makefile.
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com> <20110406080522.GZ13963@pengutronix.de> <4D9C826C.5050802@gmail.com> <20110407222348.GE17049@n2100.arm.linux.org.uk>
In-Reply-To: <20110407222348.GE17049@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 03:23 PM, Russell King - ARM Linux wrote:
> On Wed, Apr 06, 2011 at 08:10:36AM -0700, Justin P. Mattock wrote:
>> o.k.!! Thanks for having a look at this..
>
> Could you queue this up in the patch system with everyone's acks please?
> You don't need to include a Cc line for any of my addresses (and I'd
> prefer it not to be in submissions.)
>
> Thanks.
>


o.k. I resent.. hopefully I got the addresses proper.

Justin P. Mattock
