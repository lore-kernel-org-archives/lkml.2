Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0EPBPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 21:15:53 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:59964 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0EPBPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 21:15:52 -0400
Date: Sat, 15 May 2010 20:14:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Greg Thelen <gthelen@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: Consider the entire user address space during
 node migration
In-Reply-To: <1273962913-8950-1-git-send-email-gthelen@google.com>
Message-ID: <alpine.DEB.2.00.1005152014200.12742@router.home>
References: <AANLkTil4zgqBtBAp--P8VdynpbohxVosQ-qFiQQ_c5Bb@mail.gmail.com> <1273962913-8950-1-git-send-email-gthelen@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok. Looks okay to me.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

