Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab0DIL32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 07:29:28 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:39993 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0DIL30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 07:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ac8VWXz4A//K2rfXlxbYXWTRqfQuM/uulmHoN0dOqwJJt3U96qjAVX5VAP+o0bABxL
         jCsSWOVsruRtCN1sD8rSHv6koA1/GlgrktXsD9qgw0En+K8d9cwsdaYt408liOsHxi8f
         aR9A7IwjjeoPWpsAq9ntiJKcdLTt4DYZHitXs=
Message-ID: <4BBF0F93.2010601@garzik.org>
Date: Fri, 09 Apr 2010 07:29:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.33: libata issues with VIA SATA/PATA controller
References: <201004091114.o39BEILl018939@mercury.physics.adelaide.edu.au>
In-Reply-To: <201004091114.o39BEILl018939@mercury.physics.adelaide.edu.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 07:14 AM, Jonathan Woithe wrote:
> I'll look into the alternative console methods to see if I can capture a
> full output from the failing kernel.  However, it will be at least two weeks
> before I can do this because that's the earliest I'll be physically back at
> the machine for an extended period of time (I could probably run quick tests
> sooner).


We won't be able to help without the full dmesg from the failing kernel...

	Jeff


