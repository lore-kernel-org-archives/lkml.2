Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0LLPUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 10:20:09 -0500
Received: from mail2.charite.de ([193.175.72.31]:57502 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752814Ab0LLPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 10:20:07 -0500
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 10:20:07 EST
Date: Sun, 12 Dec 2010 16:11:12 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Costly Context Switches
Message-ID: <20101212151112.GE26583@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently made a parallel installation of dovecot-2.0 on my mailbox
server, which is running dovecot-1.2 without any problems whatsoever.

Using dovecot-2.0 on the same hardware, same kernel, with the same users and same
mailboxes and usage behaviour results in an immense increase in the
load numbers.

Switching back to 1.2 results in a immediate decrease of the load back
to "normal" numbers.

This is mainly due to a 10-20 fold increase of the number of context
switches. The same problem has been reported independently by Cor
Bosman of XS4All, on different hardware (64bit instead of 32bit, real
hardware instead of virtual hardware).

So, now the kernel related question: How can I find out WHY the
context switches are happening? Are there any "in kernel" statistics I
could look at?

I'm running an Ubuntu kernel: 2.6.32-27-generic-pae #49-Ubuntu SMP

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
