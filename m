Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0K3JIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:08:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38841 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0K3JIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:08:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jxO/1bM4OLD1l8Ko3rHI8D7tpfL/DKyBxy6Jg/b+1W4TrNOq7GEczsKBBNR4zeSPp/
         dt4yD8IXXX7di3GFw34fYZxxFfUbM1ZjTQ8h3JEV7ankXRsofZAg/J8YcrV9lYiQz9yK
         9sGcaTYym11iorbCmL8jnEzqvRS/NL/OX7J+4=
Date: Tue, 30 Nov 2010 01:08:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>, Philipp Merkel <mail@philmerk.de>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid: egalax: Rework to include Joojoo and Wetab
 support
Message-ID: <20101130090843.GB3952@core.coreip.homeip.net>
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1011291248290.981@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011291248290.981@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 12:50:05PM +0100, Jiri Kosina wrote:
> 
> How are we going to handle this? Dmitry, what is your plan with input-mt 
> slots changes?
> 

Hmm, I could create a branch for MT work and you could pull from it...

Henrik, have you set up your tree yet?

-- 
Dmitry
