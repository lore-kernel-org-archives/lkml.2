Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab0LNSkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:40:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43052 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab0LNSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:40:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fKPNB/BvaBG0z+ekonv9CGo/RuJqnLJyVJcUrNLeFYoYqKtrPDSl/Uh3XDf9oWPfye
         lkGsQpRtqNUlj12aVSAKKjcct/kh84goOSQMpu4zv2H9+Jn2/8dUWY0rmyWb+kpAYc2M
         m3MbUOu5jEBktrxPzGvYBMPOvStZ+5pKuzFqM=
Date: Tue, 14 Dec 2010 10:40:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the input tree with Linus' tree
Message-ID: <20101214184000.GA11384@core.coreip.homeip.net>
References: <20101214132658.ce0f5bc6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214132658.ce0f5bc6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 01:26:58PM +1100, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next merge of the input tree got a conflict in
> include/linux/input.h between commit
> 86b17f76f462db460d6d916e105a4c44cb353e36 ("Input: document struct
> input_absinfo") from Linus' tree and commit
> a528f721b7c0ba70433dbddf5947eea458c3e36a ("Input: document new trkid
> field in struct input_dev") from the input tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Hi Stephen,

The fix looks good and if you could carry it for a while that would be
great - I try to avoid cross-merging branches if possible...

Thanks.

-- 
Dmitry
