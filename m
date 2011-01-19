Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1ASAve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:51:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38912 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1ASAvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:51:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GrM+rUFjtTLBCL9ZKCLOCaTrsockIrF5O/03V2fUrDwGTuIaw159zU7A0UDuaK+to+
         D1vhlJ9n9G4luEAWQOFAD+2EN8V7YLX8C2Qi+0qM0EyMtNG3Ov4Z80HoUOq5hYqrydk9
         +oNybJjh/DODcOGRZXjo+zBiUOJRLsKz6ZXZc=
Message-ID: <4D36358E.40106@pobox.com>
Date: Tue, 18 Jan 2011 19:51:26 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jian Peng <jipeng@broadcom.com>
CC: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver
References: <4CFF58D2.4040006@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFFCD56.6050608@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFFD3EB.10800@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFFE29C.7080205@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com> <4D000C8B.5040904@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FD72B23@IRVEXCHCCR01.corp.ad.broadcom.com>,<20110111182323.GG15933@htj.dyndns.org> <E18F441196CA634DB8E1F1C56A50A874319FA7E37B@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874319FA7E37B@IRVEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2011 01:55 PM, Jian Peng wrote:
> Here is new patch based on your suggestion (against 2.6.37 release)
[...]
> I will test host controller made by other vendors and report issues soon.

Any updates?

	Jeff



