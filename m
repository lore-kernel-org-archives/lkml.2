Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab1D1Q3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:29:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19358 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1D1Q3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:29:32 -0400
Date: Thu, 28 Apr 2011 09:29:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh@suse.de
Subject: Re: linux-next: Tree for April 28 (staging/wlan-ng: prism2)
Message-Id: <20110428092917.039071a4.randy.dunlap@oracle.com>
In-Reply-To: <20110428152534.7240a49c.sfr@canb.auug.org.au>
References: <20110428152534.7240a49c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DB995E3.013A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 15:25:34 +1000 Stephen Rothwell wrote:

> Hi all,


drivers/staging/wlan-ng/prism2fw.c:1115: warning: the frame size of 4288 bytes is larger than 2048 bytes

Noooooo.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
