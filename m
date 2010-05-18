Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab0ERGun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:50:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:8114 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0ERGuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qtwLHcnSaUMCMcizzdUlt1h7FSDLHxkh6TEBrv7qgtbd5bcpLkKXypdTBmk8fgi39I
         QzTdQV7LQfElm27aPyDgTmmxiNfem5I7ZKENmgZMVfdf6NWhNu1GJXevlQ6K5o6wtabU
         yn2w57kL8/KHRNI4ptF0q957hM+InqP8SMvvw=
Subject: (tsc) clock too slow on Core-i7/ASRock X58
From: "=?gb2312?Q?=B1=F6=CE=F7=C3=C9?=" <binximeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: BinXimeng@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 08:56:57 +0200
Message-ID: <1274165817.7859.16.camel@eee51>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a problem with the system clock being off roughly 10 minutes a 2
hours on a Xeon W3250 (like Core-i7 920) using the 2.6.34 Linux and tsc
clocksource. Switching to hpet seems to improve the situation
momentarily, however, are there any other thoughts on this matter?

What I find odd is that the processor speed in dmesg (after TSC
calibration message) is 2.8 GHz, whereas BIOS says @2.67GHz, might that
be related?

