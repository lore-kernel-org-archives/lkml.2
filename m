Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab2BZPoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 10:44:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34032 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2BZPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 10:44:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jrnieder@gmail.com designates 10.43.117.135 as permitted sender) smtp.mail=jrnieder@gmail.com; dkim=pass header.i=jrnieder@gmail.com
Date: Sun, 26 Feb 2012 09:44:05 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: John Hughes <john@Calva.COM>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        John Hughes <john@calvaedi.com>, John Hughes <john@atlantech.com>,
        Jeff Layton <jlayton@poochiereds.net>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [Sony Vaio TX3] TPM chip prevents machine from suspending a
 second time
Message-ID: <20120226154405.GA12590@burratino>
References: <20110328100846.0ba2e039@tlielax.poochiereds.net>
 <4D90C472.3090908@linux.vnet.ibm.com>
 <20110328141241.06a435f8@tlielax.poochiereds.net>
 <20110328154543.1bb979fd@tlielax.poochiereds.net>
 <4D91157F.2020502@linux.vnet.ibm.com>
 <20120121170157.GA18053@burratino>
 <4F1DC8A3.60901@linux.vnet.ibm.com>
 <4F252441.3090507@calvaedi.com>
 <4F258E4C.8020606@linux.vnet.ibm.com>
 <4F265E74.4040602@Calva.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F265E74.4040602@Calva.COM>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Hughes wrote:
> On 29/01/12 19:22, Stefan Berger wrote:

>> Thanks. Please try the attached patch.
>>
>> I am not sure whether this is the right way to go, though: Is it a
>> problem particular to this BIOS + Board or a general problem of
>> this BIOS? Is it specific to the TX3 or to all VAIOs?
>
> I'll try the patch.

How did it go?

Curious,
Jonathan
