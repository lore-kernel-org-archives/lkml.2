Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2LEW1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:27:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60923 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab2LEW1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:27:42 -0500
Date: Wed, 5 Dec 2012 23:27:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: John <da_audiophile@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Additional compiler optimization options
Message-ID: <20121205222738.GB6239@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	John <da_audiophile@yahoo.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1354745355.79857.YahooMailNeo@web140001.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354745355.79857.YahooMailNeo@web140001.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 02:09:15PM -0800, John wrote:
> Came across this and wanted to show it to others
> more knowledgeable for feedback.  Is this value-added or not?
>  Upstream URL is: https://gitorious.org/rummage/random_patches

This only makes sense if you can show a noticeable performance
improvement using one of the those -march options with at least one
benchmark from those which we have now in the kernel.

And even that use case is limited because the majority of the kernel
builds out there are distro kernels built with -mtune=generic so it
would only make difference for people building their own kernels, who
are a small minority, relatively.

Thanks.

-- 
Regards/Gruss,
    Boris.
