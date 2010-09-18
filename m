Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0IRUmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 16:42:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34746 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0IRUmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 16:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=UeM2H5gfzlPxboToPtemPvTOkadwjMvqeSurc0QRPdP585fF/cRFEtXvZv1t+QAaZl
         QWLMByzom8RKb4m16XS+grNPJWY1kIRwtWKrpePxlK/znYnxVCEppMlLv6Mpj8vK/ify
         MC9AAvE/peihcBP93vI4f7XPWFSU/Y75xoUuo=
MIME-Version: 1.0
In-Reply-To: <4C94FDB4.7020206@tmr.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org> <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
 <20100910184652.GA24470@redhat.com> <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
 <20100910192403.GA24582@redhat.com> <Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com>
 <4C8AC0F5.5080206@kernel.org> <20100911014612.GA26517@redhat.com> <4C94FDB4.7020206@tmr.com>
From: Mike Snitzer <snitzer@gmail.com>
Date: Sat, 18 Sep 2010 16:42:25 -0400
Message-ID: <AANLkTikQv+NmcwXeWebcCzxjR69YN0qY-en1mLeXS4-n@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for
 bio-based dm
To: Bill Davidsen <davidsen@tmr.com>
Cc: jack@suse.cz, mst@redhat.com, linux-ide@vger.kernel.org,
        James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, hch@lst.de,
        agk@redhat.com, k-ueda@ct.jp.nec.com, vst@vlnb.net,
        linux-scsi@vger.kernel.org, rusty@rustcorp.com.au,
        linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, swhiteho@redhat.com,
        chris.mason@oracle.com, tytso@mit.edu, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        rwheeler@redhat.com, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 1:58 PM, Bill Davidsen <davidsen@tmr.com> wrote:
>
> He is commenting on the process rather than the code, since he tells you
> that he lacks time to review your complex changes to his work, so your
> saying that he hasn't found errors in it is muddy thinking as best.
>
> He provided a patch and would like it tested properly before you drop a
> bunch of stuff on top of it, to be sure it gets proper exposure and wider
> testing. That sounds like sound software development to me. It sounds as
> though you feel that the inclusion of your additional work is critical and
> can't possibly wait until the next -rc or release, and I have missed the
> reason why your stuff can't wait until it can drop on mainline code..

Well that was just completely incoherent yet clearly antagonistic drivel.

Seems you're joining multiple peoples' response to this issue and
attributing that completely misinformed combination to "he".

Thanks but we have this completely under control.

Mike
