Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1CVFof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 01:44:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61286 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab1CVFoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 01:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=X8tIKlmftZX0zCrBTgns8mesYDWtq1TyvNsm6qi1cNu6aR6CRzeG21sI1tGGVUoUz5
         TZ8Pp+e9ke1nzeL+voPCiAaeUiPujnQ1EgD6qbLfLI+ZB8EWfiV/sFRZJDv/Dxo2mCvu
         mdDVthKZ4S/i3SPFU/SpN5/41JgjQ8AgrmfiA=
Date: Tue, 22 Mar 2011 13:44:16 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC]A question about kernel's development
Message-ID: <20110322054412.GA2856@gmail.com>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20110322033312.GA2219@gmail.com>
 <20110322035148.GM14675@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322035148.GM14675@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 11:51:48PM -0400, Steven Rostedt wrote:
> On Tue, Mar 22, 2011 at 11:33:14AM +0800, Harry Wei wrote:
> > Hi us,
> >    I wanna know our kernel's development 
> > procedure for details. I just realize
> > when we get a stable release, we must 
> > merge trementous patches into kernel.
> > I often watch -rc kernels, -git kernels, 
> > , -mm kernels and know their promulgators.
> > But i don't know their relationships and
> > sequences for shaping stable ones.
> 
> Well, a quick answer is that when we fix a bug, we tag it with
>  Cc: stable@kernel.org
> 
> Then when it is applied to Linus's tree, Greg then can choose to pull it
> into the stable branch.
Yeah, it is true.
> 
> I also believe that Greg spends lots of lonely nights looking into git
> commits, drinking his favorite Latte and cursing at all the git patches
> that fix a bug that didn't have a Cc: stable tag attached. He use to
> have a huge mane of hair on his head before taking over as stable
> maintainer ;)
Hmmm, so we should learn all the details, which can 
ease maintainers' burden.
Steven, thanks for your help.

Thanks.
Best Regards.
Harry Wei.
> 
> -- Steve
> 
> >    Okay, now we want to develop 2.6.38 
> > to 2.6.39. How many specific steps should we
> > do? In fact, i recognize some. But i want to 
> > understand all the concrete procedures. Could
> > anyone help me, thanks in advance.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
