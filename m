Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0D1P5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:57:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49312 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0D1P5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:57:53 -0400
Date: Wed, 28 Apr 2010 08:56:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Joern Engel <joern@logfs.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       logfs@logfs.org
Subject: Re: linux-next: Tree for April 28 (logfs)
Message-Id: <20100428085604.0566092a.randy.dunlap@oracle.com>
In-Reply-To: <20100428164341.cee2911a.sfr@canb.auug.org.au>
References: <20100428164341.cee2911a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BD85AF3.0041:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When CONFIG_BLOCK is not enabled:

fs/logfs/super.c:142: error: implicit declaration of function 'bdev_get_queue'
fs/logfs/super.c:142: error: invalid type argument of '->' (have 'int')

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
