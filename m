Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab0ICSnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:43:50 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:32137 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753895Ab0ICSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:43:46 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 0cc2maYVM1lGOwXWb1mY3zIy46QMKEUSmePu6dN9hjuHBAT
 IaN_rHAB23OeVIoC3f1Xx.QYx1LZV18ybrMFtEUxR4EJb_EnBhEQPVg6cApK
 UbQN9NmInjGPQZmcIh.R1sasg2CSVzc.U.JkW4MCh7SLFh2spSmRUHC3wzHk
 EXppwtoDEq41QH230qF7bJeGDKcF1r49NhPk67geerBAAYZA7qAZQZeRZJqr
 k.5PEXOv91N__thCC.eIf9fvarfg8BnWR_W3qrw--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Sep 2010 13:43:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] percpu: use percpu allocator on UP too
In-Reply-To: <4C8121BC.7040609@kernel.org>
Message-ID: <alpine.DEB.2.00.1009031343210.10602@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org>
 <4C74DB05.7000101@cs.helsinki.fi> <alpine.DEB.2.00.1008250846590.13026@router.home> <4C762734.1030402@kernel.org> <4C8121BC.7040609@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As much as I can review looks okay.

Reviewed-by: Christoph Lameter <cl@linux.com>


