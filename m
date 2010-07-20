Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550Ab0GTUXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:23:45 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44964 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761510Ab0GTUXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:23:41 -0400
Date: Tue, 20 Jul 2010 15:19:49 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression 2.6.33->2.6.34: OOPS at boot, kmalloc corruption?
In-Reply-To: <AANLkTikZLVYavu0EeQJ2VelymBoC2LQZTfc44FOAzwe4@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1007201518470.9608@router.home>
References: <AANLkTimVSZ584-dTIJFalTStvT1kPBQmnDdgUTsoSFQT@mail.gmail.com> <AANLkTikZLVYavu0EeQJ2VelymBoC2LQZTfc44FOAzwe4@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010, Pekka Enberg wrote:

> It's slab corruption that can be cause by many things. Can you please
> try to reproduce with CONFIG_SLUB_DEBUG_ON=y?

Or simply reboot and add a parameter slub_debug to the other parameters.

