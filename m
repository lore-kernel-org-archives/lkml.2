Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1FIQfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:35:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1FIQft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:35:49 -0400
Message-ID: <4DF0F653.8080600@oracle.com>
Date: Thu, 09 Jun 2011 09:35:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Connor Hansen <cmdkhh@gmail.com>
CC: linux-kernel@vger.kernel.org, ravi@jetztechnologies.com,
        arvino55@gmail.com, greg@kroah.com, akpm@linux-foundation.org,
        joe@perches.com
Subject: Re: [PATCH RESEND]Remove a warning for drivers/edac/i82975x_edac.c
References: <20110609030401.GA2615@gmail.com> <BANLkTim_=2kWXAzkECC4A3t9uxGERwBU7g@mail.gmail.com>
In-Reply-To: <BANLkTim_=2kWXAzkECC4A3t9uxGERwBU7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DF0F65F.0051:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/11 21:26, Connor Hansen wrote:
> When I compile 3.0.0-rc2+ I don't get this warning.
> please make sure this issue still exists.
> 

It still happens for me -- but only on i386 (X86_32).
Did you build for 32-bit target?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
