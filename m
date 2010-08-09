Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab0HISPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:15:30 -0400
Received: from mail.bitdefender.com ([91.199.104.2]:49106 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0HISP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:15:29 -0400
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
Date: Mon, 9 Aug 2010 21:15:25 +0300
Cc: viresh kumar <viresh.kumar@st.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <4C5F9B25.8080401@st.com> <201008091735.11105.mihai.dontu@gmail.com> <4C6040FC.2020702@gmail.com>
In-Reply-To: <4C6040FC.2020702@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201008092115.25992.mihai.dontu@gmail.com>
X-BitDefender-Spam: No (592)
X-BitDefender-SpamStamp: v1, build 2.8.85.101985, rbl score: 0(0),
 bayes score: 500(0), pbayes score: 500(0), neunet score: 592(592),
 flags: [NN_S_ENDS_IN_FULLSTOP_BGU; NN_LEGIT_SUMM_400_WORDS], SQMD:
 690e444a78ad77329fe0e7f63b3f00ca.fuzzy.fzrbl.org, total: 592(775)
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.1.0 on
 elfie.dsd.hq, sigver: 7.33272
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 August 2010 20:55:08 Justin P. Mattock wrote:
> On 08/09/2010 07:35 AM, Mihai Donțu wrote:
> > On Monday 09 August 2010 12:43:16 Justin P. Mattock wrote:
> >> On 08/09/2010 02:35 AM, viresh kumar wrote:
> >>> On 8/9/2010 2:31 PM, Matti Aarnio wrote:
> >>>> On Mon, Aug 09, 2010 at 12:26:24PM +0530, viresh kumar wrote:
> >>>>>> I missed this information in my last mail. We are using git
> >>>>>> send-email for sending patches. As patches will go through
> >>>>>> Microsoft exchange server only, so they are broken.
> >>>> 
> >>>> Let your boss complain to your IT keepers.
> >>>> "These are Machine-to-Machine messages, they must not be modified!"
> >>>> 
> >>>> 
> >>>> It would probably be "against corporate policy" to use gmail for these
> >>>> emails...
> >>> 
> >>> We got one solution: Upgrade Exchange server to SP2.
> >>> Lets see if our IT department does this upgradation.
> >> 
> >> that or just blast them with some cryptology..i.e. pretty sure if your
> >> message was encapsulated(AH/ESP) they couldn't tweak it.. but then
> >> sending such encryption to a public list would require a _key_ on the
> >> other side.. wishful thinking...
> >> (just a thought)...
> > 
> > Shouldn't just signing the message be enough? The server (normally) would
> > not alter it, otherwise it will break the signature (which is a too
> > obvious bug even for Microsoft). Or am I missing something here?
> > 
> > PS: A local SMTP with DKIM signing capabilities could be another
> > possibility, assuming Exchange does not break such signatures.
> 
> yeah that would probably be just enough to get through without Microsoft
> mucking around with the font etc.., but the biggest problem(I see) with
> the encryption is having the key on the other end of the line.

Wait. I don't think we're on the same page here. I'm talking about message 
signing (which does not require the receiving end to have any key - it's the 
same plain text e-mail with a blob after it) while you refer to actually 
encrypting the message. Mm? Or am I being extremely slow today? :-)

-- 
Mihai Donțu
