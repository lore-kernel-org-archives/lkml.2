Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0FPDQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 23:16:48 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38414 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab0FPDQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 23:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iyCRMpyjL3EwXbIvioVN/l81Q08oCXvEJsf4nCaC4JMUyFQOjgDVCgwSa0zKf1qm6M
         NNsNAGwlBXbVGuYwyGJ059PlmkUW6He+eAq2svqGMFXS+r46rqtBoQLyUnOD1XGxFHet
         Qt6e/VWz+uJIWMy2rFcmt8hHWhtD7atjVemnE=
MIME-Version: 1.0
Date: Tue, 15 Jun 2010 21:16:45 -0600
Message-ID: <AANLkTimBXLzaHyPvj0vpbW8yWVxdnepi704b9CGpaKrs@mail.gmail.com>
Subject: [ANNOUNCE] MDB - Merkey Debugger 2.6.34-06-15-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://merkeydebugger.googlecode.com/files/mdb-2.6.34-06-15-2010.patch

Some more fixes for 2.6.34 after testing on a 4 x Opteron HP Proliant

FIXES:

Fixed Crash in display_process
added more X86_64 support for register parser
fixed keyboard interrupt lockup with keyboard while debugger is active
on Compaq based systems
 Added NMI support for initial keyboard and sysrq handling.

Jeff
