Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0JKQcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:32:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62584 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab0JKQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:32:04 -0400
Date: Mon, 11 Oct 2010 09:31:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 11 (regulator)
Message-Id: <20101011093147.34062ccf.randy.dunlap@oracle.com>
In-Reply-To: <20101011162959.86e40961.sfr@canb.auug.org.au>
References: <20101011162959.86e40961.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 16:29:59 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101008:


When CONFIG_REGULATOR_DUMMY is not enabled:


linux-next-20101011/drivers/regulator/dummy.c:41: error: redefinition of 'regulator_dummy_init'
linux-next-20101011/drivers/regulator/dummy.h:28: note: previous definition of 'regulator_dummy_init' was here


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
