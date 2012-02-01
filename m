Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2BAOkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:40:14 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:34811 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753722Ab2BAOkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:40:12 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MMTsYM0VM1l2s._oSoLyjah0FovsSJu9ZuTLl_suXGL.18n
 2EIs6UbZRTzrTu2GIcAvShDdrZvc4bHwQBjSHJC5yiUWHr.RwSkhit01TeGi
 qJoZNLGjCtyNVmSUJP0zz9rMAGxxqB5smTGJcXyiXoajlLqEpdZZVxGHEfg6
 VoW9WHOAJn7IguquGFNp7xlXMMkzY7GIeEZaHd2Pewbk4OuifM7lpTD1QNzz
 KHsgYWAiv6LDzAvDSzXj8sGilv4SvWkDIrGAhoULcmuyP8GHITWTRk5.WfXk
 lhk.1VYCE9ZSanDPdYQjhX5oVTEnR6FN5Nl9ExXf4BWu8CeIrPstYa8ek8pY
 QUAQvxzH7zORtFnOVELuImLv5H88ETjrS_U.tkE8wx_3HaMJ91_LKeYK_NlV
 EcsiTBdCYfZIKfQ0WQ8nGUWSjTiua63R6v.Y-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 1 Feb 2012 08:40:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Young <dyoung@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
In-Reply-To: <20120201083032.GA6774@localhost>
Message-ID: <alpine.DEB.2.00.1202010839540.28991@router.home>
References: <20120201063420.GA10204@darkstar.nay.redhat.com> <CAOJsxLGVS3bK=hiKJu4NwTv-Nf8TCSAEL4reSZoY4=44hPt8rA@mail.gmail.com> <4F28EC9D.7000907@redhat.com> <20120201083032.GA6774@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012, Wu Fengguang wrote:

> > BTW, I think tools/slub/slabinfo.c should be included in tools/vm/ as
> > well, will move it in v2 patch
>
> CC Christoph. Maybe not a big deal since it's already under tools/.

Sure. You have my blessing.

