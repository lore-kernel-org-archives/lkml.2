Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0JGUC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:02:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40961 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0JGUC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FOY+LHymT3Kg1WX5a5HaJtrK53IMc43Qfa6xq/wY68extCFkNjoB7B89OvFU4OYOBv
         yGKKUgvk2ZGtpEg7w5hngenechd7spXOLulsKBJwLVNpa9505lz9CnsL+3fbGh5YRN8L
         Pez/rYT8k324JOvjXRKRFb1+csMsQZAWSMB6M=
MIME-Version: 1.0
In-Reply-To: <1286481532.23836.27.camel@c-dwalke-linux.qualcomm.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
 <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com> <AANLkTi=8Et=Z6zrzbZa3L0MO=cBjjh7L=XU2=PDEbzWW@mail.gmail.com>
 <1286481532.23836.27.camel@c-dwalke-linux.qualcomm.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 7 Oct 2010 16:02:30 -0400
X-Google-Sender-Auth: mQv60msGdghaYopbM627pGeOFec
Message-ID: <AANLkTi=j2n-X+-zkas8HdL1awo7Lcyxwofts6FjU8vj6@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 15:58, Daniel Walker wrote:
> On Thu, 2010-10-07 at 15:48 -0400, Mike Frysinger wrote:
>> i dont think hijacking the "ttyS" namespace is acceptable, even if
>> it's behind a Kconfig.  other people have tried in the past (myself
>> included) and been shot down.  sounds like a shim for crappy userspace
>> apps that blindly assume /dev/ttyS*.  is that really an issue anymore
>> though now that things like /dev/ttyUSB* are so common and people are
>> used to picking between multiple serial sources ?
>
> It also creates a ttyJ* which uses the same interfaces as the code for
> ttyS* .. I don't think allowing a Kconfig option to shim this in as a
> ttyS* is all that bad .. This driver is only going to be used in rare
> cases for debugging , having a ttyS* is just a level of flexibility ..

how is that any different from:
ln -s ttyJ0 /dev/ttyS0
-mike
