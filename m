Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab0JRCi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 22:38:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55823 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0JRCi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 22:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xu1GiQc3NBcR7ZoBdvG4pvwvFDCaN2lVcEU/BzjiltVvXx9qDwGDLKnx27mPnF2SRR
         DMm81WARx9OxRu22W1B+34TJoZuRLhexFea7YXU0yFI1vDKF5hEbaZsMI/ODqF4Tg2Oe
         Rf0Ak7GoaniURVWOuqRnjuSPyNHgjgInzyZVM=
Date: Mon, 18 Oct 2010 10:43:35 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: scripts/extract-ikconfig only works on uncompressed and
 CONFIG_KERNEL_GZIP kernels
Message-ID: <20101018024335.GB5281@cr0.nay.redhat.com>
References: <loom.20101018T024559-314@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20101018T024559-314@post.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:48:46AM +0000, Alex Elsayed wrote:
>I have a kernel that was compiled with LZMA compression (CONFIG_KERNEL_LZMA). I
>wish to extract the .config from it without running it, but the script to do so
>does not support such kernels. How could I go about fixing this, so that the
>script supports other compression modes than just gzip?
>

I am not surprised at all, that program looks for gzip signature,
which is gzip only apparently. :)
