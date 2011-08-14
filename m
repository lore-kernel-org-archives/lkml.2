Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1HNKgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 06:36:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61060 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab1HNKgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 06:36:25 -0400
Date: Sun, 14 Aug 2011 12:36:45 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: bluetooth on by default
Message-ID: <20110814103645.GA2226@fancy-poultry.org>
References: <201108140403.p7E43h82025349@dcnode-02.unlimitedmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108140403.p7E43h82025349@dcnode-02.unlimitedmail.net>
Organization: private site
X-OpenPGP-KeyID: 0xE9002778
X-OpenPGP-Fingerprint: C661 CE20 7105 B0DB 49B5  CDB2 298C 801B E900 2778
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
X-Provags-ID: V02:K0:7AHalgDwxFsDj7lgoXiJwmXEqILv4YSH91OrBjnBczq
 8PrJcCl+bM12OK33lG+7KCJOZoy6pfMY6k+x9sBfpW2imvo6IC
 5lrRBm0wA6lE96gJPXpe72Ga/JHMriVAemQUaD2yEdsm3/U3Ze
 I/ZLuM94XsSBczBJs9ezds6BzgsqYpu7MNtNNwjd1zAit3ttuk
 hD2TD9FOhtexpGfphFHtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.08.2011, J. Bakshi wrote: 

> I have compiled the latest 3.0.1 kernel. Everything is fine,
> but bluetooth is always on after boot. How can I toggle this
> behavior ? 

This is not kernel related. Put something like

 "rfkill block bluetooth"

in your rc.local and you'll get what you want.

