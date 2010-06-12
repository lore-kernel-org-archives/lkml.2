Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0FLCtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:49:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50432 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab0FLCtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hfDoksZcwolkMQ0cI6AQ/mclOEiLJ63mXbLT1EmD6HgmLAW4BSiqNru1H1Zh9EnHzy
         TbCqO7sUlrQpJdnnpNKKbEW6CbM66tD0IbPFoNP8EBjzd0WHO7hPXvp3b2h9r9K5UJaA
         YlVBeXHAP3OL/GEERvgeIwIOMiFcABcgHvfIA=
MIME-Version: 1.0
Date: Fri, 11 Jun 2010 20:49:21 -0600
Message-ID: <AANLkTimkQeUWKcVUL2Lxq9OqeUimnZwvROdIfOFAZD-_@mail.gmail.com>
Subject: [ANNOUNCE] Open CWorthy Linux Libaries 6-11-2010 posted
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Download is at:

http://cworthylinux.googlecode.com/files/cworthy-06-11-2010.tar.gz

FIXES

Corrected pthread concurrency issues with ncurses and ncursesw.  These
libraries are not pthread safe on linux 2.6.33 and later kernels and
require mutexes for access to any of the screen
refresh() calls or they will corrupt the video display

removed vitriolic messages from the code and comments

this version supports multiple update panels with pthread safe calls
to ncurses libraries.  Supports VT100, VT220, XTerm, and Linux
terminals.  Dumb terminal and ANSI still have some issues but these
problems are ncurses related.  Sample IFCON program included.

This version was tested on a 4 processor Opteron HP Proliant Server

Jeff
