Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0EKRU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:20:29 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50996 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab0EKRUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:20:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IfJ4pkhTJWnG50Jl3sHPXlLPceFCe5wH0Zv75SeozbZ97gBbyaz4yhrYCxN15n7X2H
         777A2BWtZ1H0HUfsBEUD1lNoWwgQucyuUhriRv2r/baqDF5KtxBLdvG3um9ff6XNaPJV
         zDCdeDWG4QVbz1MgMv7bHYA62lFqLKHsm5hiM=
Date: Tue, 11 May 2010 21:20:20 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] w1: DS2760: move EXPORT_SYMBOL() to function
 declarations
Message-ID: <20100511172020.GA22212@oksana.dev.rtsoft.ru>
References: <1273597433-29241-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1273597433-29241-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 07:03:53PM +0200, Daniel Mack wrote:
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Evgeniy, I can take it via battery-2.6.git tree, but I'll need
your Ack.

Thanks!
