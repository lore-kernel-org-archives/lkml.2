Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab0CXTYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:24:43 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:38518 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab0CXTYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:24:42 -0400
Date: Wed, 24 Mar 2010 14:23:25 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com, mingo@elte.hu,
       adobriyan@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       yi.zhu@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 4/4] percpu: don't implicitly include slab.h from
 percpu.h
In-Reply-To: <1269420538-18039-5-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1003241423100.14329@router.home>
References: <1269420538-18039-1-git-send-email-tj@kernel.org> <1269420538-18039-5-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


