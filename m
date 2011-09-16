Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab1IPTbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:31:40 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37967 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1IPTbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:31:39 -0400
X-Auth-Info: u2excJAoGVxAsLaxkQyCZ220e/fB2FOVtFYhIZauSGQ=
Message-ID: <4E73A419.70907@grandegger.com>
Date: Fri, 16 Sep 2011 21:31:37 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: x86@kernel.org,
        SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Willy Lambert <lambert.willy@gmail.com>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64
 systems
References: <4E731565.5050307@grandegger.com> <63081.1316200771@turing-police.cc.vt.edu>
In-Reply-To: <63081.1316200771@turing-police.cc.vt.edu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 09:19 PM, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 16 Sep 2011 11:22:45 +0200, Wolfgang Grandegger said:
>> There are 64-bit systems out there, like the ATOM N450, which
>> have ISA slots.
> 
> That's a scary thought...

Well. Actually we need it for Intel Atom N450 PC/104-Plus SBCs.

> 
>> +if X86_32
>> +
>>  config EISA
> 
> But not as scary as the implication that the N450 has ISA but *not* EISA??!?

Ok, then I will allow EISA as well.

Wolfgang.
