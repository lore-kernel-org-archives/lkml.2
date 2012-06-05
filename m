Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602Ab2FEJtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:49:23 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:2238 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758120Ab2FEJtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:49:22 -0400
Message-ID: <1338889756.4971.34.camel@x61.thuisdomein>
Subject: Re: Why minor is still 8 bit?
From: Paul Bolle <pebolle@tiscali.nl>
To: George Shuklin <george.shuklin@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 05 Jun 2012 11:49:16 +0200
In-Reply-To: <4FCDD308.8070204@gmail.com>
References: <4FCC0E6D.9000206@gmail.com>
	  <20120604013504.GU30000@ZenIV.linux.org.uk> <4FCC3151.1040503@gmail.com>
	  <4FCCDE2B.3020306@schaufler-ca.com> <4FCD0591.2050504@gmail.com>
	  <4FCD5869.8000306@zytor.com> <4FCD5BF3.30707@gmail.com>
	 <1338888208.4971.30.camel@x61.thuisdomein> <4FCDD308.8070204@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 05 Jun 2012 09:49:16.0749 (UTC) FILETIME=[78B03FD0:01CD4300]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 13:36 +0400, George Shuklin wrote:
> This is a limitaiton of LMV itself. I'm talking about making those LV 
> active (visible in system). When you trying to activate too much LV, you 
> will get 'device io ctl failed' message.

What is the exact text of that message? Where is it found (stderr,
dmesg, ...)? Do you know what prints it (kernel, user space)? Do you run
into this issue when trying to activate the 256th LV, or later, or
earlier?


Paul Bolle

