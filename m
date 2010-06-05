Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab0FEWno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:43:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47406 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab0FEWnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LpyqxYMZfvmFDCIkUR2fCZKdnOEnsiOfsNtzei1948TXe56MpaIj3B4E1+gVHQkZFh
         SDVsZJjeObyqzRPrKCDN7fnk36OIEDvcCsuJC2ftL6jL++F2MnyjCcxoK6yFkiRr8F8L
         1QnEe+NkROdjV2qATf+t4rrYdbow/T9OHgZ1U=
MIME-Version: 1.0
Date: Sat, 5 Jun 2010 16:43:41 -0600
Message-ID: <AANLkTin7bqvrQFANBxiZay9tOyEX-_m1M7lNS7aVbbID@mail.gmail.com>
Subject: [ANNOUNCE] Merkey's Kernel Debugger 2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Located at:

http://merkeydebugger.googlecode.com/files/mdb-2.6.34-06-05-10.patch7

Have not tested the APIC IPI calls yet but should work.  Let me know
if there are problems.  I disable the hw_breakpoints interface with
MDB is loaded because it is not well designed and to be honest,
virtualizing DR6 and trying to handle these types of events outside of
a debugger core causes a lot of problems.  Has support for x86_64 and
works under it however, I have not completed the dissassembler with
the newer x86_64 instructions, so some of them do not display properly
and do not detect the 64 bit flag, but will finish this at a later
date as I need it.  I do most of my work on 32 bit anyway and will
work on it as I have time.  Someone else is welcome to add it and send
me back the changes since this is the only thing missing for full
x86_64 features -- finished everything else.

Jeff
