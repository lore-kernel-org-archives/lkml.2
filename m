Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab0FUNbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:31:01 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:37347 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932237Ab0FUNbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:31:00 -0400
Message-ID: <4C1F698D.2060105@example.com>
Date: Mon, 21 Jun 2010 15:30:53 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: What's up with Linux git repo?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 7635290218865914136
X-Ovh-Remote: 83.24.108.92 (doa92.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I update regularly with git config:


[core]
         repositoryformatversion = 0
         filemode = true
         bare = false
         logallrefupdates = true
[remote "origin"]
         fetch = +refs/heads/*:refs/remotes/origin/*
         url = 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
[branch "master"]
         remote = origin
         merge = refs/heads/master

Until few days ago there were updates but now I don't see any. Will 
somebody tell me what's going on? Why there are no new updates? Is it 
because Linus has vacation now, as I read in another thread?

Regards,

Piotr Hosowicz

