Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab0EJXO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:14:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61871 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab0EJW6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:14 -0400
Message-ID: <4BE88F22.3060408@oracle.com>
Date: Mon, 10 May 2010 15:56:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
CC: "David J. Choi" <david.choi@micrel.com>
Subject: Re: bug: micrel phy init (2.6.34-rc7)
References: <4BE88BED.4030400@oracle.com>
In-Reply-To: <4BE88BED.4030400@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BE88F83.000B:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/10 15:42, Randy Dunlap wrote:
> Loading the micrel phy driver BUGs (no device present):
> 
> [  623.821462] BUG: unable to handle kernel NULL pointer dereference at (null)
> [  623.822164] IP: [<ffffffff8123c9f0>] strcmp+0x6/0x44
> [  623.822164] PGD 7d4bd067 PUD 7d6bb067 PMD 0 
> [  623.822164] Oops: 0000 [#1] SMP
> 
> 
> Full kernel log and config are attached.
> 
> Not a regression -- this is a new driver.

OK, I see that this was reported & fixed on May-06.  :)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
