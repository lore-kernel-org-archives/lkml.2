Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab1CaTsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:48:35 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:28098 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753809Ab1CaTse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:48:34 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cdjhld0VM1ke0jSENfDWNuiez9Hg7Fnboaag8W8keuJ8Ml6
 tOPWsrNEE.89JVEG_HhM_q3ZnFz1xNcCW44jDvSgl.p0yv1ZzjV4QBXg7SVV
 wlOIyUF9v_lUZLbTr36lTFOqhAD8LsYRst0bXECZ10TblgCEMaMzVhaGELUS
 9rTIi6SBuh2egxh4xtz9RnOJ4Y7ojic5MSZugyoK65Ppwv.5na1JUVE_EOYR
 Xr.dl_c3r.AbIhFlStS_xZwG48Zw.A6ssiEaHvRby78wNcJWDUr14lu8jyBb
 8u3OI0or92mGfUHgAgUQ07E786SEac16x425TkUlkhgqU7igq
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 31 Mar 2011 14:48:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, yinghai@kernel.org,
        torvalds@linux-foundation.org, aarcange@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: Clean up memory model related configs in
 arch/x86/Kconfig
In-Reply-To: <1301594566-10139-2-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1103311447460.25184@router.home>
References: <1301594566-10139-1-git-send-email-tj@kernel.org> <1301594566-10139-2-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Tejun Heo wrote:

> * Remove bogus dependency on ARCH_SELECT_MEMORY_MODEL from
>   ARCH_FLATMEM_ENABLE.  ENABLE configs don't interfere with
>   SELECT_MEMORY_MODEL.  They just need to indicate whether the
>   specific memory model is supported.

Reviewed-by: Christoph Lameter <cl@linux.com>

