Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1ITSVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:21:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53827 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1ITSVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:21:39 -0400
Date: Tue, 20 Sep 2011 11:21:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: EXT4: lockdep complaints on 3.1-rc4+
Message-ID: <20110920182133.GB4187@core.coreip.homeip.net>
References: <20110920175551.GA4187@core.coreip.homeip.net>
 <CA+5PVA7WA6QorzgiOHEDw9HCoLO0UbGYMS34r3Ds01w854YoHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7WA6QorzgiOHEDw9HCoLO0UbGYMS34r3Ds01w854YoHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 01:59:05PM -0400, Josh Boyer wrote:
> On Tue, Sep 20, 2011 at 1:55 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi,
> >
> > Not sure if it has been reported but I just got the following lockdep
> > warning on 3.1-rc4+ + my input queue (which does not touch FS code at
> > all):
> 
> IIRC, that should be fixed with
> 8c0bec2151a47906bf779c6715a10ce04453ab77, which is in -rc5
> 

Ah, excellent. Sorry for the noise.

-- 
Dmitry
