Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0JNW2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:28:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab0JNW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:28:07 -0400
Date: Thu, 14 Oct 2010 18:28:06 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        kyle@mcmartin.ca
Subject: [PATCH 0/3] alpha: __do_IRQ just say no
Message-ID: <20101014222805.GA8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Please test and review the following changes which convert alpha away
from calling __do_IRQ, which is deprecated and will be nuked at some
point in the future.

It's been cross compiled, and should be bisectable, I've put a bit of
effort into ensuring that each patch stands on its own, so if there are
any issues, debugging them should be fairly trivial.

(In most cases, it's literally just a renaming + using handlers, the
 generated code is almost byte-for-byte identical.)

Thanks!
 Kyle
