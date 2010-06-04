Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab0FDFan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:30:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54963 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab0FDFab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MfLcpTugmrqicayBD1QYqx77UGlD4SCmQeXlbjmM7iZSNS0/qBf96psGsInsG6AWBA
         mCXjaqpecDOGxg50KdQ5WWklSnqy0aAyyMRm1wTCQGP6aHQpY9XSRol+uwPZnKlf0jyu
         lmoyRKHW0Dddb2VEH3aKKuWS/wcJE4kJoA2Co=
MIME-Version: 1.0
Date: Thu, 3 Jun 2010 23:30:30 -0600
Message-ID: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com>
Subject: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite unfreeze/Thaw 
	event
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

causes the FS Thaw stuff in fs/buffer.c to enter an infinite loop
filling the /var/log/messages with junk and causing the hard drive to
crank away endlessly.

Also, stack frame corruption in the kernel.  tracking it down  with
MDB.  shows up with temporary int1 breakpoints set at times.  Really
FUCKED UP.

Jeff
