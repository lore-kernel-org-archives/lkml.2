Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0ICRQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:16:41 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:32757 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753758Ab0ICRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:16:40 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NE6nsI0VM1kW2DDm4KDU7BCGmGPxlzCSRtndS_q9FFrciz_
 xMs.XBi.s.bBCg0OTMUMGAmR9725_KFSLYwT93V2uQlYyW6RynGB7u8jWtrH
 sCmzKqDfDaSk5k73H7P2fhU1lJezUwgtsFgqMD5npU3c0nB_6Rh.L5aOmkiq
 BgGy3lnWYw.ijnR.qozWC7XMShZn_zdtxdzMHN8bszE3_ie3qn6BYl6nsFu7
 DF5nGztNVo_L1kttk7UN04emtnpUOred7cSKAxw--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Sep 2010 12:16:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/3] vmalloc: pcpu_get/free_vm_areas() aren't needed on
 UP
In-Reply-To: <4C81215E.1070108@kernel.org>
Message-ID: <alpine.DEB.2.00.1009031216250.8658@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org>
 <4C74DB05.7000101@cs.helsinki.fi> <alpine.DEB.2.00.1008250846590.13026@router.home> <4C762734.1030402@kernel.org> <4C81215E.1070108@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Chrsitoph Lameter <cl@linux.com>


