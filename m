Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0I1LS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:18:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63476 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0I1LS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JNihUalJaVzux4zTzLRLwG9vzsoCCCEe697/fFUOUFvcM804HjrfYJNqcvZXMf3c5B
         XpDnNTMlUaLKTkqVwWwXVJoUJz1C/82N5amHYUw8D35peulGJYBF/dmOL5M6vK9UuU8j
         Y0GUjgJjVe7qdnyok0UC1q41I/D34eUhsa/nE=
Date: Tue, 28 Sep 2010 15:18:22 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drivers/power: add missing kfree(wm831x_power) in
 wm831x_power_remove()
Message-ID: <20100928111822.GB22734@oksana.dev.rtsoft.ru>
References: <1285571232.31251.1.camel@mola>
 <1285571411.31251.5.camel@mola>
 <20100927150507.GA13754@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100927150507.GA13754@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 08:05:07AM -0700, Mark Brown wrote:
> On Mon, Sep 27, 2010 at 03:10:11PM +0800, Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks! Applied */3.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
