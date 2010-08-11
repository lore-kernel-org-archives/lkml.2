Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab0HKTEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:04:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42612 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0HKTEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J9xUxvE+142U3nnyvpZkerCdaex7ZvYxNACy74fBJx+/sn6p/HhbPOSBxjb8LbTeSU
         7Y9nliwJDVXZY6ZvBByXzcbNjw1fWb0lf7sici6C3wr8q3hemTC90Btk/aU9RDf/v83Z
         1UdB7DqwpQ4aYlPTLXL7yZAyX/0ha2dBz45Rw=
Subject: Re: Linux Kernel GDB tracepoint module demo release
From: Thiago Jung Bauermann <thiago.bauermann@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: gdb@sourceware.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=4_QnAyY+zcuXwVpPkESjpF7yfMb1RunMQaK7f@mail.gmail.com>
References: <AANLkTi=4_QnAyY+zcuXwVpPkESjpF7yfMb1RunMQaK7f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 16:03:49 -0300
Message-ID: <1281553430.32376.2.camel@hactar>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hui,

On Thu, 2010-08-12 at 00:34 +0800, Hui Zhu wrote:
> GDB Tracepoint (http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html)
> is new feature that make GDB can debug real-time program.
> I think this feature is very fit for debug Linux Kernel.  So I make a
> lkm to make kernel support it. You can get it in
> https://code.google.com/p/kgtp/

Jim Blandy worked on GDB tracepoint support for the kernel too. I don't
know how his work compares to yours, you might be interested in having a
look:

http://www.red-bean.com/trac/tracepoints/

-- 
[]'s
Thiago Jung Bauermann

