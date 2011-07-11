Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1GKUdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:33:01 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27884 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1GKUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:33:00 -0400
Date: Mon, 11 Jul 2011 22:32:58 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Arnaud Lacombe <lacombar@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid Wunused-but-set warning
In-Reply-To: <20110710165333.8c7f9620.rdunlap@xenotime.net>
Message-ID: <alpine.LNX.2.00.1107112224080.10944@swampdragon.chaosbits.net>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net> <CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com> <CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
 <CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com> <CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com> <20110710110241.7650e03f.rdunlap@xenotime.net> <alpine.LNX.2.00.1107110051420.2818@swampdragon.chaosbits.net>
 <20110710160722.ae763029.rdunlap@xenotime.net> <alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net> <20110710165333.8c7f9620.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-660627870-1310416378=:10944"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-660627870-1310416378=:10944
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 10 Jul 2011, Randy Dunlap wrote:

> On Mon, 11 Jul 2011 01:21:36 +0200 (CEST) Jesper Juhl wrote:
> 
> > On Sun, 10 Jul 2011, Randy Dunlap wrote:
> > 
> > > On Mon, 11 Jul 2011 00:56:57 +0200 (CEST) Jesper Juhl wrote:
> > > 
> > > > On Sun, 10 Jul 2011, Randy Dunlap wrote:
> > > > 
> > > > > On Sun, 10 Jul 2011 12:49:20 -0400 Arnaud Lacombe wrote:
> > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > On Sun, Jul 10, 2011 at 12:28 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > > > > > > On Sun, Jul 10, 2011 at 7:24 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > > > > > >> Hi,
> > > > > > >>
> > > > > > >> On Sun, Jul 10, 2011 at 12:16 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > >>> On Sun, Jul 10, 2011 at 12:24 AM, Raghavendra D Prabhu
> > > > > > >>> <rprabhu@wnohang.net> wrote:
> > > > > > >>>> Hi,
> > > > > > >>>>    I am seeing Wunused-but-set warning while make nconfig.  Looks like
> > > > > > >>>>    active_menu is not used. Removing it fixes the warning.
> > > > > > >>>>
> > > > > > >>>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> > > > > > >>>
> > > > > > >>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> > > > > > >>>
> > > > > > >> Out of curiosity, what is your status to ACK such patch ?
> > > > > > >
> > > > > > > What kind of status do you need to ACK such a simple patch?
> > > > > > >
> > > > > > As per Documentation/SubmittingPatches:
> > > > > > 
> > > > > > <<
> > > > > > 13) When to use Acked-by: and Cc:
> > > > > > The Signed-off-by: tag indicates that the signer was involved in the
> > > > > > development of the patch, or that he/she was in the patch's delivery path.
> > > > > > 
> > > > > > If a person was not directly involved in the preparation or handling of a
> > > > > > patch but wishes to signify and record their approval of it then they can
> > > > > > arrange to have an Acked-by: line added to the patch's changelog.
> > > > > > 
> > > > > > Acked-by: is often used by the maintainer of the affected code when that
> > > > > > maintainer neither contributed to nor forwarded the patch.
> > > > > > >>
> > > > > > 
> > > > > > That said, it is not a strong requirement... unfortunately. So, let's
> > > > > > have some fun and go ACK thousand of trivial patch just to generate
> > > > > > traffic on the LKML and give myself self-importance :-)
> > > > > 
> > > > > Acked-by: is mostly used as a weak version of Reviewed-by:
> > > > > and the "definition" in SubmittingPatches is not accurate IMO.
> > > > > I.e., it can be used by anyone.
> > > > > 
> > > > 
> > > > Interesting. I was under the impression that Reviewed-by: was a weaker 
> > > > thing than Acked-by: - I certainly have been using it as such.
> > > > 
> > > > I've always interpreted Acked-by: as being something you could apply if 
> > > > you were the author, maintainer or other person with similar strong 
> > > > background knowledge of the code. Where Reviewed-by: could be used by 
> > > > anyone, as long as they had taken the time to read the patch and try and 
> > > > understand what was going on and the result/conclusion looked good.
> > > 
> > > I don't see it in SubmittingPatches, but there was some discussion at the
> > > time (IIRC!!) that Reviewed-by: indicates that you are willing to support/fix
> > > the patch if the patch author(s) disappear.  I.e., you are willing to take
> > > some ownership responsibility of the patch.
> > > 
> > > or I could be dreaming...
> > > 
> > I'm not going to claim that I recall all the discussion that went on at 
> > the time, there was quite a bit IIRC (and I'm too lazy to read up on all 
> > of it). But to me it seems to make sense that if you have strong knowledge 
> > of/involvement with the code being patched then you can offer your 
> > Acked-by: after reviewing the patch. If you don't have such 
> > knowledge/involvement but have nevertheless reviewed the code and found it 
> > to be OK, then you can signal that with a Reviewed-by:.
> > 
> > In any case, you can't expect people to base their Acked-by/Reviewed-by 
> > replies on some conclusion in some email thread that happened years ago 
> 
> ack that.
> 
> > but was never written down in some document in the repository. 
> > It is only reasonable to expect people to behave according to the rules 
> > laid out in SubmittingPatches and similar documents, and those rules 
> > currently seem to support my interpretation, not yours.
> 
> In Documentation/SubmittingPatches, Reviewed-by: contains a "Reviewer's
> statment of oversight."  That alone is more formal than Acked-by: is.
> 
> Plus this paragraph acknowledges that "Review" can be a serious and
> time-consuming task, not a simple "looks OK to me":
> 
> "A Reviewed-by tag is a statement of opinion that the patch is an
> appropriate modification of the kernel without any remaining serious
> technical issues.  Any interested reviewer (who has done the work) can
> offer a Reviewed-by tag for a patch.  This tag serves to give credit to
> reviewers and to inform maintainers of the degree of review which has been
> done on the patch.  Reviewed-by: tags, when supplied by reviewers known to
> understand the subject area and to perform thorough reviews, will normally
> increase the likelihood of your patch getting into the kernel."
> 
> I can see little about Acked-by: that is formal when it comes to patch review.
> E.g.:
> 'Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
> has at least reviewed the patch and has indicated acceptance.  Hence patch
> mergers will sometimes manually convert an acker's "yep, looks good to me"
> into an Acked-by:.'
> 

I'll concede to those points. My original understanding/reading was 
different but you make some good points.
 

> But do as you like.  Which parts of SubmittingPatches do you think
> support your interpretation?
> 

Originally, text such as this:

"Acked-by: is often used by the maintainer of the affected code..."

"Reviewed-by:, instead, indicates that the patch has been reviewed and 
found acceptable ... I do not (unless explicitly stated elsewhere) make 
any warranties or guarantees that it will achieve its stated purpose ..."

But I take that back. Your interpretation now seems like the more correct 
one to me.

> and should we have this line:
> 	Acked-by: is not as formal as Signed-off-by:.
> changed to:
> 	Acked-by: is not as formal as Signed-off-by: or Reviewed-by:.
> e.g.?
> 

Might make sense.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-660627870-1310416378=:10944--
