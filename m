Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2FOTaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:30:12 -0400
Received: from mail2.charite.de ([141.42.206.200]:35742 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab2FOTaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:30:11 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2012 15:30:10 EDT
Date: Fri, 15 Jun 2012 21:19:34 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: BUG: Bad rss-counter state
Message-ID: <20120615191934.GB19364@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.4.2, I got a few of those:

# fgrep -1 "BUG: Bad rss-counter state" kern.log
Jun 10 17:35:57 mail kernel: [436940.510027] BUG: Bad rss-counter state mm:f09c8700 idx:1 val:-2
Jun 10 17:35:57 mail kernel: [436940.510044] BUG: Bad rss-counter state mm:f09c8700 idx:2 val:2

Jun 14 08:52:09 mail kernel: [314161.698470] BUG: Bad rss-counter state mm:f052c700 idx:1 val:-4
Jun 14 08:52:09 mail kernel: [314161.698487] BUG: Bad rss-counter state mm:f052c700 idx:2 val:4

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
