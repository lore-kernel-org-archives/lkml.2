Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab0LSSTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 13:19:46 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:49935 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab0LSSTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 13:19:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=coLJafR9wj04X2+xm+uoOZ9crFkvPYaO/rMZzdY16xqQYnWZhDHTC9I/QS+XntTvs8
         ivfPr6J3SzkeWM8mRxofPfk4ZMS+omwX5WY13l62bFZJ+8uBMfSxCbezaS14GZrsGvp1
         qEtuAy+1cnOP/FkgEnTv/phhXJWtpyAEfLyjs=
Message-ID: <4D0E4CBE.5060504@lwfinger.net>
Date: Sun, 19 Dec 2010 12:19:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #22562] Regression in 2.6.37-rc1 - logs spammed with "unable
 to enumerate USB port" - bisected to commit 3df7169e
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera> <6Ue85L6pKCJ.A.MoF.2ffDNB@chimera> <4D0E2DD7.4060607@lwfinger.net> <20101219163427.GA22994@suse.de>
In-Reply-To: <20101219163427.GA22994@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 10:34 AM, Greg KH wrote:
> On Sun, Dec 19, 2010 at 10:07:51AM -0600, Larry Finger wrote:
>>
>> Yes, this regression is still present in 2.6.37-rc6. I'm trying to debug this
>> with very little success.
> 
> To be fair, you seem to have the only machine with this problem :(

I know, which is why I feel that I need to debug it.

Larry
