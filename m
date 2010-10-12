Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab0JLRM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:12:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43178 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0JLRMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=NAQNbJljp9NQBS/tbLJMhGWyaXmKNt3/M1fHAgpzPqI8v+niDxBu7WzKjc6mCDIj37
         6qM2ltvJKxRhrN4ZHkWDKp88xwCQCLadzzyAWP5Rjbhhha/gXI//+MI892u1p4Vh/7mw
         SjCB5voP7CET3Z3J340ZcuPo5+gTWKmZTbG5I=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Chris Vine <chris@cvine.freeserve.co.uk>
Subject: Re: Lenovo S12 2.6.36-rc7 lockup
Date: Tue, 12 Oct 2010 19:12:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7; KDE/4.4.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20101010135912.76eb61b7@boulder.homenet>
In-Reply-To: <20101010135912.76eb61b7@boulder.homenet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010121912.19724.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 10 października 2010 o 14:59:12 Chris Vine wrote:
> Hi,
> 
> kernel 2.6.36-rc7 completely locks up my Lenovo S12 notebook on boot-up.
> It happens early enough in boot-up that nothing appears in any of the
> system log files.  The last message printed to the console is "Using
> IPI - No Shortcut mode".
> 
> The lock up does not occur with kernel 2.6.35.6.  I do not know in what
> version of 2.6.36-rc this first arose.
> 
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=20172
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
