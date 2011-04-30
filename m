Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab1D3JqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 05:46:24 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43628 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab1D3JqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 05:46:22 -0400
Date: Sat, 30 Apr 2011 11:46:09 +0200
From: Florian Mickler <florian@mickler.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>, oliver@neukum.org,
        linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media] dib0700: get rid of on-stack dma buffers
Message-ID: <20110430114609.53103d67@schatten.dmk.lab>
In-Reply-To: <4DBB2E72.3030800@infradead.org>
References: <1301851423-21969-1-git-send-email-florian@mickler.org>
	<alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>
	<4DBB2E72.3030800@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 18:32:34 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> As it is a trivial fix, I'll be picking it directly.

Zdenek reported in the bug that it doesn't fix all instances of the
warning. 

Regards,
Flo
