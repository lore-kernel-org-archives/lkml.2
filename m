Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1BCV6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:58:17 -0500
Received: from mvp.visionpro.com ([63.91.95.19]:50741 "EHLO
	extern.visionpro.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857Ab1BCV6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:58:16 -0500
User-Agent: Microsoft-Entourage/12.28.0.101117
Date: Thu, 03 Feb 2011 13:58:08 -0800
Subject: Re: Memset very slow
From: "Brian D. McGrew" <brian@visionpro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-kernel@vger.kernel.org>
Message-ID: <C97064F0.479C8%brian@visionpro.com>
Thread-Topic: Memset very slow
Thread-Index: AcvD7XD13KVxtl3JakOj6K6KweEb3g==
In-Reply-To: <20110203213158.62baa54c@lxorguk.ukuu.org.uk>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2011 21:58:08.0463 (UTC) FILETIME=[713C3DF0:01CBC3ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/11 1:31 PM, "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:

>> So, my question is, can someone explain to me what is going on here?  I am
>> not convinced this is a kernel problem just because a new kernel fixed it;
>> but, if there were changes related to this in the kernel, then what is the
>> oldest version I should be looking at to fix my issues?
> 
> The newer kernel does several things that may be relevant - the obvious
> one is that it rewrites and corrects MTRR data if it doesn't like what
> the BIOS handed out. That would fit with dramatic slowdowns in memory
> performance being fixed.

The Dell precsion-linux mailing list almost immediately pointed me here:
https://bugzilla.redhat.com/show_bug.cgi?id=581933

Which seems like it is my problem and the fix seems to work for me.

-brian

