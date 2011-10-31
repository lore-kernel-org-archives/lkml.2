Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522Ab1JaPip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:38:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60672 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab1JaPin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:38:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: t-kristo@ti.com
Cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        "Basak, Partha" <p-basak2@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gadiyar, Anand" <gadiyar@ti.com>, sameo@linux.intel.com,
        tony@atomide.com, "Hilman, Kevin" <khilman@ti.com>,
        johnstul@us.ibm.com, "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures for omap3
In-Reply-To: Your message of "Fri, 28 Oct 2011 15:03:36 +0300."
             <1319803416.12919.2.camel@sokoban>
From: Valdis.Kletnieks@vt.edu
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com> <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com> <alpine.DEB.2.00.1109240020510.22872@utopia.booyaka.com> <CAP05o4Lwk2uUz5ou84GQsrsBdjW-FEYP-55pBzH+a74hP4g1Dw@mail.gmail.com> <cbad72cea703d117067f7c628f7db806@mail.gmail.com> <1317127327.3820.31.camel@sokoban> <CAP05o4J75jGLTH8prOGD79Mte4DOg9ukgwe3V-KHFnB1Q-fi4w@mail.gmail.com> <CAP05o4K2EzAKDgC9EdfEURCfcM=M7TRJdBuAtRafL2RHg+qTag@mail.gmail.com> <1318505283.23199.4.camel@sokoban> <CAP05o4LUpo=H9_2sXswYzk_vkgyvm2F2qT3Pdo6cqSzMKMYi5A@mail.gmail.com>
            <1319803416.12919.2.camel@sokoban>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1320075479_32791P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 31 Oct 2011 11:37:59 -0400
Message-ID: <152227.1320075479@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4EAEC0DE.0141,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1320075479_32791P
Content-Type: text/plain; charset=us-ascii

On Fri, 28 Oct 2011 15:03:36 +0300, Tero Kristo said:
> Hi Again,

> I created a new version of the patch which should be better than this
> hack, I'll send it as an RFC to the l-o list in a bit.
> On Thu, 2011-10-13 at 13:49 +0200, Munegowda, Keshava wrote:
> > On Thu, Oct 13, 2011 at 4:58 PM, Tero Kristo <t-kristo@ti.com> wrote:
> > > On Thu, 2011-10-13 at 09:12 +0200, Munegowda, Keshava wrote:
> > >> On Tue, Sep 27, 2011 at 6:48 PM, Munegowda, Keshava
> > >> <keshava_mgowda@ti.com> wrote:
> > >> > On Tue, Sep 27, 2011 at 6:12 PM, Tero Kristo <t-kristo@ti.com> wrote:
> > >> >> On Tue, 2011-09-27 at 08:04 +0200, Basak, Partha wrote:
> > >> >> Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
> > > Texas Instruments Oy, Porkkalankatu 22, 00180 Helsinki, Finland. Business ID: 0115040-6. Domicile: Helsinki
> Texas Instruments Oy, Porkkalankatu 22, 00180 Helsinki, Finland. Business ID: 0115040-6. Domicile: Helsinki

Moral: Just leave current street addresses out of it. :)

And can we *please* trim irrelevant stuff?  You top-posted a 2 line reply,
followed by the entire note, which a bunch of kernel developers got to scroll
through and wonder if they missed an in-line comment. *Especially* after the
top part had one line that it wasn't clear if it was a top-posted sig line gone
wrong, or 3 attempts to get an address right for inclusion in a patch.


--==_Exmh_1320075479_32791P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOrsDXcC3lWbTT17ARAjfaAKDcIcwP1SUqRa0i9EgwPlKai6OKXwCgiDvp
Mp4qAd/UEGsFBldTRFKjxEM=
=bLst
-----END PGP SIGNATURE-----

--==_Exmh_1320075479_32791P--

