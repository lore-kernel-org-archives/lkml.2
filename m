Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab2GWVi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:38:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37659 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2GWViy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:38:54 -0400
Date: Mon, 23 Jul 2012 22:38:51 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Anton Pyrogovskyi <asp@penguinishly.org.ua>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: PROBLEM: Re: [PATCH] pci: Rework ASPM disable code
Message-ID: <20120723213851.GB1343@srcf.ucam.org>
References: <2806511343077258@web6f.yandex.ru>
 <201207232317.33764.rjw@sisk.pl>
 <2809911343078330@web6f.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2809911343078330@web6f.yandex.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:18:50AM +0300, Anton Pyrogovskyi wrote:
> 24.07.2012, 00:17, "Rafael J. Wysocki" <rjw@sisk.pl>:
> > Does nouveau detect your GPU with the Matthews commit?
> 
> Yes, nouveau does work but its performance leaves a _lot_ to be wished.
> I do game development and so am pretty much forced to use the proprietary driver whether I want to or not.

If nouveau works and nvidia doesn't then I'm afraid you probably need to 
bring it up with nvidia - it sounds like a bug in their driver. It 
probably needs to explicitly disable aspm for this hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
