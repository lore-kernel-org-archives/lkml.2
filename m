Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0LJRgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:36:22 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:63144 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab0LJRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:36:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rXoIBZmOBRUX5VqPiQwISLYSaKsmoz1v8/3ug1TqkaQUVDTOrur09CXY+7HwlzzaUH
         2Kv5ZWpTqm5k5y/3qB4pRdVeqzsHXgv/C/jathbye9oynweX9wSdbkQqAgsVbyUt0BA1
         73r9uZBSl1zhmJTjPoldFYUtKDK7omNi8LEDY=
Date: Fri, 10 Dec 2010 09:36:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
Message-ID: <20101210173611.GA1630@core.coreip.homeip.net>
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292001842-5000-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 06:24:02PM +0100, Henrik Rydberg wrote:
> +#define MT_TOOL_ENVELOPE	2	/* rectangle corner - legacy use only */

Legacy to me implies we can upgrade, but this is hardware limitation.
Can we say "rectangle corner - used by older hardware"?

-- 
Dmitry
