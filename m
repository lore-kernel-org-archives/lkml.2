Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2FMNyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:54:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab2FMNyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:54:35 -0400
Date: Wed, 13 Jun 2012 15:54:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mahmood Naderan <nt_mahmood@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: logging on kernel panic
In-Reply-To: <20120613133927.73c44f09@pyramind.ukuu.org.uk>
Message-ID: <alpine.LRH.2.00.1206131552440.6369@twin.jikos.cz>
References: <1339589919.53487.YahooMailNeo@web111718.mail.gq1.yahoo.com> <20120613133927.73c44f09@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Alan Cox wrote:

> > Hi everybody
> > If a system receives kernel panic during boot, will it be logged somewhere?
> 
> Often not.. especially if it is fatal. Look up netconsole however.

Well your machine's BIOS can still be providing non-volatile sotrage which 
under recent kernels registers itself with 'pstore', and you can get the 
dmesg+panic from there then (provided you have all the necessary bits, 
such as APEI, compiled in and enabled).

-- 
Jiri Kosina
SUSE Labs

