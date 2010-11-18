Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953Ab0KSABg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:01:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222Ab0KRX5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:57:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
        "Borislav Petkov" <bp@amd64.org>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
In-Reply-To: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ATV3yiK8i4C.A.xhE.Pib5MB@chimera>
Subject: [Bug #22552] AMD boot freeze bisected to b126b4703afa4010b161784a43650337676dd03b
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Nov 2010 00:42:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22552
Subject		: AMD boot freeze bisected to b126b4703afa4010b161784a43650337676dd03b
Submitter	: Borislav Petkov <bp@amd64.org>
Date		: 2010-11-02 17:03 (17 days old)
First-Bad-Commit: http://git.kernel.org/linus/b126b4703afa4010b161784a43650337676dd03b
Message-ID	: <20101102170335.GC24927@aftab>
References	: http://marc.info/?l=linux-kernel&m=128871752109913&w=2


