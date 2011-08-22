Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1HVQ5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:57:54 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41711 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab1HVQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:57:53 -0400
Subject: Re: [PATCH 3/4] string: introduce memchr_inv
From: Pekka Enberg <penberg@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Joern Engel <joern@logfs.org>,
        logfs@logfs.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1314030548-21082-4-git-send-email-akinobu.mita@gmail.com>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
	 <1314030548-21082-4-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 22 Aug 2011 19:57:50 +0300
Message-ID: <1314032270.32391.51.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 01:29 +0900, Akinobu Mita wrote:
> memchr_inv() is mainly used to check whether the whole buffer is filled
> with just a specified byte.
> 
> The function name and prototype are stolen from logfs and the
> implementation is from SLUB.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: linux-mm@kvack.org
> Cc: Joern Engel <joern@logfs.org>
> Cc: logfs@logfs.org
> Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>

