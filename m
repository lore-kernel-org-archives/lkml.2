Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab1GJXxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:53:38 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38418 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756883Ab1GJXxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:53:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=joqcC/dkbV9fD2Gjg9dDzQNigqEM4beRp7Lh6bKlPAyk+/Ru27aWY8RiWXeI0codrxS8zGXiBS/jok3OcdWVdhLV/wJZgYdjBnfsWX1Vw5QuNlmAxiBgqGsrirfdMsIW;
Date: Sun, 10 Jul 2011 16:53:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid Wunused-but-set warning
Message-Id: <20110710165333.8c7f9620.rdunlap@xenotime.net>
In-Reply-To: <alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
	<CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
	<CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com>
	<CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
	<20110710110241.7650e03f.rdunlap@xenotime.net>
	<alpine.LNX.2.00.1107110051420.2818@swampdragon.chaosbits.net>
	<20110710160722.ae763029.rdunlap@xenotime.net>
	<alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 01:21:36 +0200 (CEST) Jesper Juhl wrote:

> On Sun, 10 Jul 2011, Randy Dunlap wrote:
> 
> > On Mon, 11 Jul 2011 00:56:57 +0200 (CEST) Jesper Juhl wrote:
> > 
> > > On Sun, 10 Jul 2011, Randy Dunlap wrote:
> > > 
> > > > On Sun, 10 Jul 2011 12:49:20 -0400 Arnaud Lacombe wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > On Sun, Jul 10, 2011 at 12:28 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > > > > > On Sun, Jul 10, 2011 at 7:24 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > > > > >> Hi,
> > > > > >>
> > > > > >> On Sun, Jul 10, 2011 at 12:16 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > >>> On Sun, Jul 10, 2011 at 12:24 AM, Raghavendra D Prabhu
> > > > > >>> <rprabhu@wnohang.net> wrote:
> > > > > >>>> Hi,
> > > > > >>>>    I am seeing Wunused-but-set warning while make nconfig.  Looks like
> > > > > >>>>    active_menu is not used. Removing it fixes the warning.
> > > > > >>>>
> > > > > >>>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> > > > > >>>
> > > > > >>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> > > > > >>>
> > > > > >> Out of curiosity, what is your status to ACK such patch ?
> > > > > >
> > > > > > What kind of status do you need to ACK such a simple patch?
> > > > > >
> > > > > As per Documentation/SubmittingPatches:
> > > > > 
> > > > > <<
> > > > > 13) When to use Acked-by: and Cc:
> > > > > The Signed-off-by: tag indicates that the signer was involved in the
> > > > > development of the patch, or that he/she was in the patch's delivery path.
> > > > > 
> > > > > If a person was not directly involved in the preparation or handling of a
> > > > > patch but wishes to signify and record their approval of it then they can
> > > > > arrange to have an Acked-by: line added to the patch's changelog.
> > > > > 
> > > > > Acked-by: is often used by the maintainer of the affected code when that
> > > > > maintainer neither contributed to nor forwarded the patch.
> > > > > >>
> > > > > 
> > > > > That said, it is not a strong requirement... unfortunately. So, let's
> > > > > have some fun and go ACK thousand of trivial patch just to generate
> > > > > traffic on the LKML and give myself self-importance :-)
> > > > 
> > > > Acked-by: is mostly used as a weak version of Reviewed-by:
> > > > and the "definition" in SubmittingPatches is not accurate IMO.
> > > > I.e., it can be used by anyone.
> > > > 
> > > 
> > > Interesting. I was under the impression that Reviewed-by: was a weaker 
> > > thing than Acked-by: - I certainly have been using it as such.
> > > 
> > > I've always interpreted Acked-by: as being something you could apply if 
> > > you were the author, maintainer or other person with similar strong 
> > > background knowledge of the code. Where Reviewed-by: could be used by 
> > > anyone, as long as they had taken the time to read the patch and try and 
> > > understand what was going on and the result/conclusion looked good.
> > 
> > I don't see it in SubmittingPatches, but there was some discussion at the
> > time (IIRC!!) that Reviewed-by: indicates that you are willing to support/fix
> > the patch if the patch author(s) disappear.  I.e., you are willing to take
> > some ownership responsibility of the patch.
> > 
> > or I could be dreaming...
> > 
> I'm not going to claim that I recall all the discussion that went on at 
> the time, there was quite a bit IIRC (and I'm too lazy to read up on all 
> of it). But to me it seems to make sense that if you have strong knowledge 
> of/involvement with the code being patched then you can offer your 
> Acked-by: after reviewing the patch. If you don't have such 
> knowledge/involvement but have nevertheless reviewed the code and found it 
> to be OK, then you can signal that with a Reviewed-by:.
> 
> In any case, you can't expect people to base their Acked-by/Reviewed-by 
> replies on some conclusion in some email thread that happened years ago 

ack that.

> but was never written down in some document in the repository. 
> It is only reasonable to expect people to behave according to the rules 
> laid out in SubmittingPatches and similar documents, and those rules 
> currently seem to support my interpretation, not yours.

In Documentation/SubmittingPatches, Reviewed-by: contains a "Reviewer's
statment of oversight."  That alone is more formal than Acked-by: is.

Plus this paragraph acknowledges that "Review" can be a serious and
time-consuming task, not a simple "looks OK to me":

"A Reviewed-by tag is a statement of opinion that the patch is an
appropriate modification of the kernel without any remaining serious
technical issues.  Any interested reviewer (who has done the work) can
offer a Reviewed-by tag for a patch.  This tag serves to give credit to
reviewers and to inform maintainers of the degree of review which has been
done on the patch.  Reviewed-by: tags, when supplied by reviewers known to
understand the subject area and to perform thorough reviews, will normally
increase the likelihood of your patch getting into the kernel."

I can see little about Acked-by: that is formal when it comes to patch review.
E.g.:
'Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
has at least reviewed the patch and has indicated acceptance.  Hence patch
mergers will sometimes manually convert an acker's "yep, looks good to me"
into an Acked-by:.'

But do as you like.  Which parts of SubmittingPatches do you think
support your interpretation?

and should we have this line:
	Acked-by: is not as formal as Signed-off-by:.
changed to:
	Acked-by: is not as formal as Signed-off-by: or Reviewed-by:.
e.g.?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
