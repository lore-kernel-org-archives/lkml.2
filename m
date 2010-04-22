Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0DVLBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:01:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:40070 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0DVLBI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 22 Apr 2010 07:01:08 -0400
Message-Id: <4BD04892020000780003B5D7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 22 Apr 2010 12:01:06 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce and use percpu_inc()
References: <4BCFFA1B020000780005CBAE@vpn.id2.novell.com>
 <4BCFF12D.60007@zytor.com>
In-Reply-To: <4BCFF12D.60007@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 22.04.10 08:48 >>>
>I was wondering mostly how many bytes this saved across
>the kernel.  If it saves a byte in one place it's not so interesting,
>but if it is all over it might make more sense.

It's about twenty places where this would get used.

Jan

