Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab2GCSsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:48:11 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:23059 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932255Ab2GCSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:48:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4nuqTWEVM1lAPi7a0ASKLiXIz27ZsSFCzwoLP8ALYzCVE3W
 InK0ZiQI8domjcxQxRmVgGw.TXUDg._bhAoPzKzAwRL84BAFdg9FSSvGYd2I
 Wg8Hrhdt4ZZDU.2ehoSP4PVgKFFzVOUri429HxXgnAz_77aSYKwj0OW1VMQN
 UFrSaSM1S2KJsvG2z.Qx1zgXv2Xrl_g.FwZZQsj_JMvc2YSSsx_qkOb6ubOy
 h5IPiYqjKYyRh2qF.50Wvhny3_jguEykxp.hP7Rtyzifhgo5zj6tM7iY8zUg
 Ttg2_nCIMpte3wBebC4MnoiDiDZ3ByX18Vpmf0XBbb6jAtGbaqC9zVDvagQF
 9c3b3fCKAAD0Q3mtDgxy8baJtrEh8zovgVqe7UFJmeVVdKcf454VoVdiCGhz
 RFqubl1El6PZNFNez4G6YauUngmuxJRWM_iw-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 3 Jul 2012 13:48:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Li Zhong <zhong@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH powerpc 2/2] kfree the cache name  of pgtable cache if
 SLUB is used
In-Reply-To: <1340618099.13778.39.camel@ThinkPad-T420>
Message-ID: <alpine.DEB.2.00.1207031344240.14703@router.home>
References: <1340617984.13778.37.camel@ThinkPad-T420> <1340618099.13778.39.camel@ThinkPad-T420>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, Li Zhong wrote:

> This patch tries to kfree the cache name of pgtables cache if SLUB is
> used, as SLUB duplicates the cache name, and the original one is leaked.

SLAB also does not free the name. Why would you have an #ifdef in there?
