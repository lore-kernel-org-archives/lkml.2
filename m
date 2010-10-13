Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0JMOwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab0JMOwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:52:44 -0400
Date: Wed, 13 Oct 2010 10:52:41 -0400
From: Casey Dahlin <cdahlin@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: A question about ZONE_DMA
Message-ID: <20101013145240.GE12467@foucault.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

So if I understand correctly, ZONE_DMA exists to separate and preserve the
chunk of memory to which older ISA cards are capable of doing DMA. The question
that arises for me is:

1) Why do /all/ 32-bit boxes have a ZONE_DMA when surely only a tiny and
shrinking number of them have a need for it?

2) Why do /any/ 64-bit boxes have a ZONE_DMA? Is there really some godless
monster out there who put an early ISA bridge and a 64-bit CPU on the same
motherboard?!

Can someone shed light on what I'm missing?

--CJD
