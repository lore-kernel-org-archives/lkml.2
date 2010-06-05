Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab0FEXVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:21:11 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:33212 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab0FEXVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:21:09 -0400
MIME-Version: 1.0
X-Originating-IP: [67.185.128.239]
Date: Sat, 5 Jun 2010 16:21:08 -0700
Message-ID: <AANLkTilOTKdY_2rQ6byxDIer_Ns-Ny0V0sM0rV9AuEkB@mail.gmail.com>
Subject: broadsheetfb and fbcon
From: Robert Emanuele <rob@emanuele.us>
To: linux-kernel@vger.kernel.org, jayakumar.lkml@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings lkml and Jaya,

I've been using the broadsheetfb graphics driver for a while now.
I've been trying to get it working with the fbcon console driver.  Has
anyone had any success with that?

While it "works", its performance is unusable as a console.  It
redraws the whole screen every new line, which may be acceptable.  A
real issue is when it tries to scroll the screen, it redraws each line
partially and then does a full screen update with each partial line.
It seems the driver is capable from Jaya's video at
http://www.youtube.com/watch?v=0Bny6qyRDWw

Are those kind of updates a limit of the broadsheet driver or fbcon?
Or more hopefully, is there a configuration change to improve this?

Thanks for your help,

Rob
