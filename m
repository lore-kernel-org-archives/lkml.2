Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab0EKVKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:10:39 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:52315 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0EKVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kOrvIpQb9QIWHJ+7BEMnmrpbeTB2Kfxk7kHnhoZjf47M7iO1YWZkR28N/CGGgOzJct
         wo5WqRQj+A6OyRQX/Et/nNJWBv8APN6A1PfWdcyaTft6DflcCUwoaC1lHbPZO2KZ4DNN
         m0Pxg6TRkzveal0QWW8Gmn1wuNOYSgG+oMjnE=
MIME-Version: 1.0
Date: Tue, 11 May 2010 23:10:36 +0200
Message-ID: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
Subject: [RFC] PyTimechart
From: Pierre Tardy <tardyp@gmail.com>
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       mathieu.desnoyers@efficios.com, arjan@infradead.org,
       ziga.mahkovec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

PyTimechart is another implementation of two very useful tools
available for the linux community:
perf-timechart ( http://blog.fenrus.org/?p=5 ) and bootchart (
http://www.bootchart.org/ )

The two tools share a common idea of making their output to SVG files.
While it is a very good idea for small traces, the generated SVG can
be very heavy, and turns out to be good stress tests for inkscape
developers...

PyTimechart is a tool that parses ftrace text traces, and display them
with the help of a very powerful dynamic plot framework, Chaco (
http://code.enthought.com/chaco/ )
The GUI makes the best it can to ease the browsing of huge traces.

The best is to look at those two 30s screencasts, to figure out how that work.

a look at mplayer startup:
http://tardyp.free.fr/pytimechart/mplayer_start.mp4
a look at ubuntu boot:
http://tardyp.free.fr/pytimechart/boot.mp4

This tool still is in the state of a prototype, I dont know if it
worth to continue to improve it or to implement it ideas in LTTV or
Kernel Shark.
It is actually very useful in its current form (
http://elinux.org/images/0/07/Effect_of_wakeups_on_Moorestown_power.pdf
), and will work without recompiling the kernel of recent distros.

the source code with build instruction is located here
http://gitorious.org/pytimechart

What do you think?

Regards,
-- 
Pierre
