Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2GXPnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:43:20 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:34187 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754696Ab2GXPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:43:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9t3ldEcVM1m28_ct1Oers8fgZR0T3a3rVaN4j5YMT2XRcPc
 VYjxlxnZ5z0UcQF38Ahz1sE4cE0va1AQs1Al6JXnie4tOZUyWoUPtZ2rJyzn
 FKMylqWz4JWLoKUnWNwnojM7JM6FWINUUZI_nkk8jK4TMAWmIu6EMRzqYjjy
 oWAhgPCWPvFbDXRDjIv9cm4g.sWB3MXGBWAlJIQ8VuOu2jiuMn3FrwzmbA.l
 mMffMS2DZ2K2uvqlsgEkiNsLwHQGwkV7GjEZc3YoY2DiKUw1Mjk2c0aQVDJr
 cTh4XUqYQrRT8wXyzMP4j8jWCJ5KbhXZjffJ_jSHAHPx3QWQvVqlcJt_U38y
 lwJ0V4LSb2EFxbTNUObnxmQSfIwDitF_ART.JdWMScTbpQmXHRIN7M_XPill
 t5cMCv92Euj.OddgXZubXh4S6dnUCDxMhjxc-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 24 Jul 2012 10:43:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] provide a common place for initcall processing in
 kmem_cache
In-Reply-To: <1343032408-20605-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1207241042550.29808@router.home>
References: <1343032408-20605-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Glauber Costa wrote:

> This patch moves that to slab_common.c, while creating an empty
> placeholder for the SLOB.

Acked-by: Christoph Lameter <cl@linux.com>
