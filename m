Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab2EJP1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:27:55 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34546 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754189Ab2EJP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:27:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: r7PRX2QVM1mGLMOFO1IlgB5xLUbQIyPbFnwx8KyU1yi8yO8
 88uFwne700VaHbTdvbrqmxdOnxufu.Dz9ppNGfWWkRHfE1iMnJyxuxMaC_Yx
 6K_fFPPwF959BFSSSvQ_CuQvGj3dIgs4jcjxN5_RZM.DX2YfBcHiXcZw6pz3
 _8O7uTcIe.J8FAG_un4UgNPWOYBJOpmt51POw910qcGQzoCLMvOS_jZyOCWu
 A0qsGgQm0UtvKEHoVC9lIAN86AMR3iNEyRRxfZvV7IUwGt4l59jnkFFZvoVi
 DcAJLxKATX8BCvFRuhxrsb_Vp6cpRpkbdID6aNZi1VZUQG3n6yAy5sX3oo4D
 RJVgfljPJv7U.opgHTA3NBN17Qs1aQNx2aqHXN8ati_xhh6o7XyW2n_jpJ_g
 kUcN.pt8G1RnzAWg5znMmbqJzVoVySw8UEJo-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 10 May 2012 10:27:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: fix incorrect return type of get_any_partial()
In-Reply-To: <1336663436-2169-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205101027370.18664@router.home>
References: <alpine.DEB.2.00.1205080912590.25669@router.home> <1336663436-2169-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Joonsoo Kim wrote:

> Commit 497b66f2ecc97844493e6a147fd5a7e73f73f408 ('slub: return object pointer
> from get_partial() / new_slab().') changed return type of some functions.
> This updates missing part.

Acked-by: Christoph Lameter <cl@linux.com>
