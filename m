Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab0D3RvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:51:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41714 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab0D3Ruh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:50:37 -0400
Date: Fri, 30 Apr 2010 10:50:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Eric Biederman <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de
Subject: Re: linux-next: Tree for April 30 (CONFIG_SYSFS=n)
Message-Id: <20100430105016.40b51636.randy.dunlap@oracle.com>
In-Reply-To: <20100430163538.7253a9e0.sfr@canb.auug.org.au>
References: <20100430163538.7253a9e0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BDB1860.017C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010 16:35:38 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100429:


When CONFIG_SYSFS is disabled:

include/linux/sysfs.h:330: error: parameter 1 ('type') has incomplete type

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
