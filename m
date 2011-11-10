Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1KJFKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:10:06 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:7771 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776Ab1KJFKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 00:10:01 -0500
Date: Wed, 9 Nov 2011 21:10:00 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <2060353978.365421.1320901800753.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4EBB16BE.9050308@zytor.com>
Subject: Re: /dev/mem "unbounded?"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.62.177]
X-Mailer: Zimbra 7.1.1_GA_3225 (ZimbraWebClient - SAF3 (Linux)/7.1.1_GA_3225)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

----- Original Message -----
> From: "H. Peter Anvin" <hpa@zytor.com>
> To: "Andrei Warkentin" <awarkentin@vmware.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>
> Sent: Wednesday, November 9, 2011 7:11:42 PM
> Subject: Re: /dev/mem "unbounded?"
> 
> 
> Well, that mechanism is broken.  The way it *should* work is that any
> region which is system RAM should be denied access, and the rest is
> accessible.  The current behavior is a hack due to the behavior of
> some
> old versions of Xorg, but that has long been fixed.
> 

Ah, ok, that seems very reasonable. Thank you for clarifying!

A
