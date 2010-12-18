Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab0LRFti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 00:49:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48460 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0LRFtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 00:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JrEoAvpXMVQaWt1HWQOFIx7VLkNnP1htpJ7KqBH+PCy7bsWr3nK5t5hcIB8chKqhRh
         CpMtR2I+qsDyDwpm9BrDHhdQubm8O4IgHrk8fJ8+Kfd78l09sAmh2cQaGdNCOOUTCLKe
         MHDr1tYMG71NGkSY7ygSpQVusI9PbfJ6dgrRo=
Date: Fri, 17 Dec 2010 21:49:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, dsd@laptop.org,
        pgf@laptop.org, James Cameron <quozl@laptop.org>
Subject: Re: [PATCH] psmouse: disable the synaptics extension on OLPC
 machines.
Message-ID: <20101218054927.GA14718@core.coreip.homeip.net>
References: <20101217210939.19b6111a@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217210939.19b6111a@queued.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 09:09:39PM -0800, Andres Salomon wrote:
> 
> OLPC has switched to a Synaptics touchpad.  It turns out that it's
> pretty useless in absolute mode.  This patch looks for an OLPC
> system (via DMI tables), and refuses to init Synaptics mode in
> that scenario (falling back to relative mode).
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Andres,

Can we do what hgpk does and add "depend on !OLPC" to the Kconfig
instead?

Thanks.

-- 
Dmitry
