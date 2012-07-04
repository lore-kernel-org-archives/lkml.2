Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2GDUGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 16:06:16 -0400
Received: from mail.snarked.org ([67.43.172.250]:60116 "EHLO mail.snarked.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab2GDUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 16:06:11 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2012 16:06:11 EDT
X-Envelope-From: <newsserv> (mail.snarked.org)
To: linux-kernel@vger.kernel.org
From: "D. Stussy" <spam+newsgroups@bde-arc.ampr.org>
Newsgroups: linux.kernel,alt.comp.os.linux.networking
Subject: Intel e1000 ethernet device, change in kernel v3.4, and jumbo frames setting DENIED.
Date: Wed, 4 Jul 2012 12:56:44 -0700
Message-ID: <jt275t$9i2$1@snarked.org>
Reply-To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-No-Archive: Yes
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3555.308
X-Newsreader: Microsoft Windows Live Mail 15.4.3555.308
Importance: Normal
X-Priority: 3
X-MSMail-Priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has been some changes to the driver such that things like checksum 
verification is offloaded from the CPU.  However, this blocks the ability to 
set a jumbo frame.  The kernel does record an error indicating that checksum 
offloading need be disabled fro jumbo frame MTU sizes to be used.  My e1000 
interfaces use the 82574L chipset.

1)  Was this an intentional change?
2)  How do I disable that function so I can set jumbo frames with "ifconfig" 
or "ip"?  I simply don't know what setting I need to pass.

Exact kernel message:  "Jumbo frames cannot be enabled when both receive 
checksum offload and receive hashing are enabled.  Disable one of the receive 
offload features before enabling jumbos." 

