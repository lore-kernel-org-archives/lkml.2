Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1JRR54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:57:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40605 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750933Ab1JRR5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:57:54 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/LuXxdfxTL6RV4W4MqaJdgeXos2mqAmNci0xSBZb
	z785tlgn5Hrx//
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: wwguy <wey-yi.w.guy@intel.com>
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
Date: Tue, 18 Oct 2011 19:57:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; i686; ; )
Cc: werner <w.landgraf@ru.ru>, David Rientjes <rientjes@google.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201110152119.58509.toralf.foerster@gmx.de> <201110181847.02971.toralf.foerster@gmx.de> <1318958013.25023.16.camel@wwguy-ubuntu>
In-Reply-To: <1318958013.25023.16.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110181957.49894.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


wwguy wrote at 19:13:33
> hmm, something broken there, it should be in the .config file, what tree
> you are using?
> 
tfoerste@n22 ~/devel/linux $ git describe
v3.1-rc10
tfoerste@n22 ~/devel/linux $ grep -B2 url .git/config 
[remote "origin"]
        fetch = +refs/heads/*:refs/remotes/origin/*
        url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
--
        merge = refs/heads/master
[remote "remote_stable"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
stable.git



-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
