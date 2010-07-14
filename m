Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0GNQcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:32:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55220 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0GNQcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K9hwk7FFQnKZb+VWnlhH1w4TGs9aN2WuRSzAKAVpaDRlhCdSUgpV10ErAdxztsz17s
         ceRjW7B7iiTn6vBYVsDR++P/vY3tHMYaaMuX+VOj8Sm34uxjgtlXUPxzBaizr1FdiEEr
         KpEcX2kD2pmsMnHgs9coUqsyQ/6z1V1QxXsw4=
Date: Wed, 14 Jul 2010 09:32:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Fix wrong dimensions check for synaptics
Message-ID: <20100714163202.GB9957@core.coreip.homeip.net>
References: <s5hwrsy2ie2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hwrsy2ie2.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 05:27:33PM +0200, Takashi Iwai wrote:
> The commit 83ba9ea8a04b72dfee2515428c15e7414ba4fc61 ommitted the return
> line for the old synaptics model accidentally.  This resulted in a wrong
> check, namely, the dimensions are checked for the old devices that don't
> support the query properly.
> 
> This patch adds the return line back.

Oops. Thanks Takashi, applied.

-- 
Dmitry
