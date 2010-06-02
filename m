Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0FBJnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:43:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33931 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab0FBJnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FZzHDABRS16WyHBhSkP6S+zu9chH80XwhK2RZeai/3WmMDK9r4TxzPO5LVhZ8ezjUO
         3wtx5Ch0aC51Kwr0Lc9ifU5FBydHLeqz2xXf9ktYP/OJP95QV1LABOupCmpD+x16KxOY
         1sVCpHx0MrVntvTZxz67qN9/BiNjP9xxfjuCo=
MIME-Version: 1.0
Date: Wed, 2 Jun 2010 03:43:06 -0600
Message-ID: <AANLkTimBVo2XadHatpo2_2_ArX6MMgk4Q2-ADw_htXuA@mail.gmail.com>
Subject: [ANNOUNCE] Cworthy Libraries for Linux Kernel Utils
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a cworthy library under ncurses for xterm and linux
terminals (also works on DOS and Windows too) years back and have
ported it to .so an .a formats.  Looks like the old NetWare inderface
and runs on Linux terminals.  Wrote a sample IFCONFIG lookalike with
the cworthy look alike portal manager that displays the same info as
IFCONFIG.  May be of use and looks a lot better than the command line.
 It is not the actual cworthy but recreates the same look and feel and
supports all the colors you would want with all the fancy menu and
screen functions.  I donate it to make the kernel utils look better
and make me feel more at home since NetWare is no more.  I use this
lib in most of my projects and it was included in the old NWFS but was
not cleaned up and broken out.  I pthread enabled it and also added
support for most of the terminals our there (ANSI and dumb not
supported but the rest are).

http://merkeydebugger.googlecode.com/files/cworthy-06-02-2010.tar.gz

Enjoy.

Jeff
