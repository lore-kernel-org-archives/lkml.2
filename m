Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1HIJyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:54:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64065 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1HIJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:54:33 -0400
Subject: Re: [PATCH] slub: fix check_bytes() for slub debugging
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
In-Reply-To: <CAOJsxLHKJT_qCsiPVCEh=+nbZ2D7+y=mJgMM+wEob395zEN6XQ@mail.gmail.com>
References: <1312709438-7608-1-git-send-email-akinobu.mita@gmail.com>
	 <1312859440.2531.20.camel@edumazet-laptop>
	 <1312860783.2531.31.camel@edumazet-laptop>
	 <CAC5umyhLuhNK55WDXTii2SFsqPNau1B9F1z+E0r0CaLNkGZfDg@mail.gmail.com>
	 <CAOJsxLHKJT_qCsiPVCEh=+nbZ2D7+y=mJgMM+wEob395zEN6XQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 11:54:31 +0200
Message-ID: <1312883671.2371.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 09 août 2011 à 12:43 +0300, Pekka Enberg a écrit :

> I'm confused. What was wrong with your original patch?
> 

Patch is good. Some future improvements will follow.


