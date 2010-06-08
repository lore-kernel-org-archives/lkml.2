Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0FHTbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:31:34 -0400
Received: from snt0-omc2-s4.snt0.hotmail.com ([65.55.90.79]:25416 "EHLO
	snt0-omc2-s4.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243Ab0FHTbd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:31:33 -0400
Message-ID: <SNT125-W2019BB92AD8F1C8BCCBFBCC3D60@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <linux@rainbow-software.org>, <mingo@elte.hu>
CC: <hpa@zytor.com>, <linux-kernel@vger.kernel.org>, <gregkh@suse.de>
Subject: RE: Windows side agrees that lowmem corruption is a problem too
Date: Tue, 8 Jun 2010 12:31:32 -0700
Importance: Normal
In-Reply-To: <201006082122.25089.linux@rainbow-software.org>
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl>
 <4C0E949D.6090002@zytor.com>
 <20100608190848.GD25985@elte.hu>,<201006082122.25089.linux@rainbow-software.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2010 19:31:33.0004 (UTC) FILETIME=[3397B4C0:01CB0741]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But please limit it to newer systems only (DMI present && year> 200?). There
> are many old machines running fine. Losing 1MB from 16MB is a bad thing.
I'd just check the amount of extended memory available.
Yuhong Bao 		 	   		  
_________________________________________________________________
Hotmail has tools for the New Busy. Search, chat and e-mail from your inbox.
http://www.windowslive.com/campaign/thenewbusy?ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_1