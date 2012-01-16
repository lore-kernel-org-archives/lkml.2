Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab2APWnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:43:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45411 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2APWnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:43:08 -0500
Message-ID: <4F14A7F8.8000004@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 17:43:04 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [Regression] Commit "tpm: Introduce function to poll for result
 of self test" breaks suspend
References: <201201160022.07176.rjw@sisk.pl> <201201162142.34096.rjw@sisk.pl> <4F149360.70604@linux.vnet.ibm.com> <201201162305.15662.rjw@sisk.pl>
In-Reply-To: <201201162305.15662.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011622-7282-0000-0000-000005ABBA4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 05:05 PM, Rafael J. Wysocki wrote:
> On Monday, January 16, 2012, Stefan Berger wrote:
>> On 01/16/2012 03:42 PM, Rafael J. Wysocki wrote:
> Well, so the problem with that is that it requires Windows to be installed
> to change the settings (i.e. the machine has no BIOS setup as we know it).
> So, practically, I really can't do that.
>
Are there any other tpm related outputs in 'dmesg' from during the boot?

    Stefan

