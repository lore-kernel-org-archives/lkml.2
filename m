Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0HMUaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 16:30:30 -0400
Received: from n70.bullet.mail.sp1.yahoo.com ([98.136.44.38]:21980 "HELO
	n70.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755323Ab0HMUa2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 16:30:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 524560.81105.bm@omp122.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=dLKPS+JdCyEFfbu8f/4Wo3avopENIRnFqm1PI7cESnwDikZo/0KD3ipkXHXQaOEyc7w6Jlkd1R4wWijgsJngRQMdGdpHdACOMxaeiwLnIRDkP1rZFLc17ShK0ZIndHKuOPp3AnADSJ6iMZofvvSzQpr0IUSaaz9oMGfs+DdYk7U=;
Message-ID: <920296.5376.qm@web180304.mail.gq1.yahoo.com>
X-YMail-OSG: hjUtgDwVM1lINKhOrtVOVneT827HqHPxaNm3.Y52le.G9S8
 HCjCiFAOZ_yfAOU_nBci1bvPwEN8Maa.2kKWc7SkjumfR1DbEefBA0.NqTIP
 VHfsWRUWVXsxuWzmfhUEOg54mtoI_PqADNHQ__2wq7HlMeRZwXVyxi1T.3DE
 zsrtnBnATOIxDYRwm34bB1QzbX7ODYrwVRtCRhiy1mICRxsDB6oiU7uw3bBq
 XpPU83mRTmO.5ukR9WG5ruzy21TeC4gM6sWkgA8yCA.lSX3aMoVu22AvYyaw
 OsFUshraA0thykjCZN7yW1OPpjvoamgNBK4lD65yNYbvVRgyjyynqTCeT0yc
 cZaG8xY2m37z2Tk4-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Fri, 13 Aug 2010 13:30:26 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv8 04/13] USB: gadget: mass_storage: moved strings handling code to composite
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1008131110130.12397-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 8/13/10, Alan Stern <stern@rowland.harvard.edu> wrote:
. 
> ... based on all
> the preceding discussion, I now think the best
> approach may be _never
> to make up a fake serial number.  Use the module
> parameter, if any, and
> otherwise issue a warning and don't have
> a serial number string
> descriptor (even though that violates the spec).


Agreed, and that's what I had asked for.  I didn't
see code faking up a serial ... did I miss such?

If so, let's see a new patch with no faking.



