Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab1CCUvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:51:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18749 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab1CCUvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:51:01 -0500
Date: Thu, 3 Mar 2011 12:50:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2011-03-02-16-52 uploaded (linux-next:
 drivers/staging/epca - missing header files)
Message-Id: <20110303125012.2a7218d4.randy.dunlap@oracle.com>
In-Reply-To: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D6FFF0B.01A0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Mar 2011 16:52:55 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.38-rc7:


Who did the (incomplete) move of some tty drivers to staging? (in linux-next)

Please also move drivers/char/digi*.h

#include "digiPCI.h"
#include "digi1.h"
#include "digiFep1.h"
=>
drivers/staging/tty/epca.c:46:21: error: digiPCI.h: No such file or directory
drivers/staging/tty/epca.c:49:19: error: digi1.h: No such file or directory
drivers/staging/tty/epca.c:50:22: error: digiFep1.h: No such file or directory

causes over 100 build errors.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
