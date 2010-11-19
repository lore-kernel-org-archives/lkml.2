Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0KSUcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:32:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0KSUcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:32:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [Bug #22552] AMD boot freeze bisected to b126b4703afa4010b161784a43650337676dd03b
Date: Fri, 19 Nov 2010 21:31:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera> <ATV3yiK8i4C.A.xhE.Pib5MB@chimera> <20101119044815.GA16472@aftab>
In-Reply-To: <20101119044815.GA16472@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011192131.34178.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Borislav Petkov wrote:
> On Thu, Nov 18, 2010 at 06:42:45PM -0500, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22552
> > Subject		: AMD boot freeze bisected to b126b4703afa4010b161784a43650337676dd03b
> > Submitter	: Borislav Petkov <bp@amd64.org>
> > Date		: 2010-11-02 17:03 (17 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/b126b4703afa4010b161784a43650337676dd03b
> > Message-ID	: <20101102170335.GC24927@aftab>
> > References	: http://marc.info/?l=linux-kernel&m=128871752109913&w=2
> 
> Also-tracked-by	: https://bugzilla.kernel.org/show_bug.cgi?id=22062
> Fixed-by	: 82e3e767c21fef2b1b38868e20eb4e470a1e38e3
> 
> :-)

Thanks, closed.

Rafael
