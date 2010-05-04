Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324Ab0EDWGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:06:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43587 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934353Ab0EDWGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:06:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "=?utf-8?q?Fran=C3=A7ois=20Valenduc?=" 
	<francois.valenduc@tvcablenet.be>
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera>
In-Reply-To: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <8VO9AsMlpMD.A.7Z.HIJ4LB@chimera>
Subject: [Bug #15788] external usb sound card doesn't work after resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  4 May 2010 23:21:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15788
Subject		: external usb sound card doesn't work after resume
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2010-04-15 10:16 (20 days old)


