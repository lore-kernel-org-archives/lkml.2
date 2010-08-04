Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab0HDHSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:18:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36431 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab0HDHSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TYwFEIGXW/JyMTYERhSYiAifnUbMD+uVWmHAqWkML2y9iE4OMPC6vm/iEXCdMJvGYE
         fcMCLDNkyWsEMgsyIQc4vJViToh9DJgJVbuCdTsJ+SYHXifWdKthSX+qHThU30fepthv
         avVDH19ULvDi/1lw9lbqjatRFmRIIThCletFk=
Date: Wed, 4 Aug 2010 15:22:46 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
Message-ID: <20100804072246.GA5263@cr0.nay.redhat.com>
References: <20100804070647.GB24064@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804070647.GB24064@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:06:48PM +0900, Simon Horman wrote:
>Hi,
>
>After all the excitement of relocating kexec-tools from
>one location on kernel.org to another last week it was
>suggested to me by Michael Neuling that the merging
>kexec-tools into the kernel tree would be a good idea.
>
>Given that there have been a bunch of issues with kexec
>on power that this would resolve. and there is precedence
>for tools in the kernel tree, this sounds entirely reasonable to me.
>So with my kexec-tools maintainer hat on, I would like to start
>a conversation about this.
>

But why? Just to draw more attentions from kernel community?
