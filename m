Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0GFQ6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:58:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52175 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0GFQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Tc25XjeSv7/zEMs8JL/2nJULzts8TxklbTkPB+B5IV6vD0jqKa5Lfw6lHJGaKaJ8tF
         57Sz4ySbloTcYBYrVHAvZDIwIPHlrWgcuxjVj12FulKv2UGGjdLuTTGWClZVuuB1rLaG
         iTihfAvnaERnsNIW/3kBhzdij4g4YmMN6cIBI=
MIME-Version: 1.0
Date: Tue, 6 Jul 2010 10:58:32 -0600
Message-ID: <AANLkTik48GNGefTrP2lb4ZwccnHbwyaEvoq_nylIkjAS@mail.gmail.com>
Subject: [ANNOUNCE] Open CWorthy 07-05-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://cworthylinux.googlecode.com/files/cworthy-07-05-2010.tar.gz

FIXES
- add redrawwin(stdscr) calls for screen refresh to tag the curses
buffer lines as changed during screen refresh to clear system messages

TODO:
- add all /bin/route and /bin/ifconfig functions to ifcon example
- add the sample field transactions for MTU settings and adatper config to ifcon
- create ctop Cworthy version of the top program for process display
- think about more kernel monitoring apps to write with the library

Jeff Merkey
