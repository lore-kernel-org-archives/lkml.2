Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0HGX7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 19:59:40 -0400
Received: from ns2.netcenter.hu ([195.228.155.139]:45579 "EHLO mail.1-click.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab0HGX7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 19:59:39 -0400
X-Greylist: delayed 1891 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Aug 2010 19:59:39 EDT
Message-ID: <0f7601cb35be$d93998c0$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: <linux-kernel@vger.kernel.org>
Subject: scsi emulation - question
Date: Sat, 7 Aug 2010 01:26:45 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3664
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

Sorry for this off-topic question, but i had no good idea where to ask.

I am looking for a solution wich can emulate SCSI device from a block device 
like loop.
I need the sg device but not for special commands, but for reading and 
writing only.
I have found only one solution until now, but i want to find better and 
faster.
The actually working is ISCSI target and initiator in one pc.
But this opens up port, and makes a lot of IP packets even if i use lo for 
this, wich is only a waste of time and resources.

Is there any solution for this allready?
Or somebody can help me where to search?
I am thinking to modify the ide-scsi to use blockdev instead of IDE 
layer....

Thanks,
Janos Haar 

