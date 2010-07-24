Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0GXSsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 14:48:17 -0400
Received: from snt0-omc3-s3.snt0.hotmail.com ([65.55.90.142]:30961 "EHLO
	snt0-omc3-s3.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368Ab0GXSsK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 14:48:10 -0400
Message-ID: <SNT125-W449B3ACDB36B8BF9EBE145C3A40@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <tj@kernel.org>, <jeff@garzik.org>, <ben.collins@ubuntu.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hmh@debian.org>
Subject: RE: support for drives larger than 2TiB
Date: Sat, 24 Jul 2010 11:48:09 -0700
Importance: Normal
In-Reply-To: <4C4AB952.9030705@kernel.org>
References: <4C4AB952.9030705@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 Jul 2010 18:48:09.0994 (UTC) FILETIME=[C31466A0:01CB2B60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I've been playing with a SATA 2.5T drive and things don't look too
> bad. All four controllers I've tested worked fine and the driver and
> kernel worked just fine. Even BIOSes don't seem too bad. At least
> the two boards I tested (both about three years old) didn't have much
> problem recognizing upto 2TiB and could access and boot fine although
> I'm fairly sure there will be BIOSes which would behave erratically.

In fact, Seagate is already selling 3TB external drives and CrunchGear
was already able to get the internal 3TB drive inside out:
http://techcrunch.com/2010/07/01/hands-on-the-seagate-freeagent-goflex-desk-3tb-external-hard-drive/

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail has tools for the New Busy. Search, chat and e-mail from your inbox.
http://www.windowslive.com/campaign/thenewbusy?ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_1