Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0FMP2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:28:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0FMP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:28:48 -0400
Date: Sun, 13 Jun 2010 17:28:45 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: Re: [REGRESSION]linux-2.6.35-rc3 in net/core/dev.c
Message-ID: <20100613152845.GA6683@fancy-poultry.org>
References: <201006131625.55481.mitov@issp.bas.bg>
 <20100613165421.7e8dda79@holly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100613165421.7e8dda79@holly>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100519 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX18wlmu+QH78oDUglyIvrGc+CFYdP7lNLwA4yob
 csPbjxLDuXQdrLZNmLZ4z+bZ0AIg0wsJa2mwL2oFvuyVcDFjbQ
 siiXaAkC52qn53uLfz+EA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.2010, Jindrich Makovicka wrote: 

> I can confirm this. Reverting of this patch fixes a regression with
> Privoxy running on localhost, where most of the connections
> (browser->proxy) stall and don't return anything.

This does also fix this bug:
https://bugzilla.kernel.org/show_bug.cgi?id=16188

