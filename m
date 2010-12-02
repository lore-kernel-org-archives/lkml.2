Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab0LBW0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:26:44 -0500
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:34987 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756250Ab0LBW0n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:26:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=wQjHzQUhxbZ1th1g1Q4ZEmIq2MYyIqrFzaLIvZ3hb/8c4cFaDZhIH7Y3Au8wHKjLzHOjUfJ4237MH0rdXSbMG7stNGspVZaIdo0plG1ouuuPj8E+m2+fc/8pEiLh0R+/hHEJt4fm6fUfuSqI4Y5xjXtl2zaJHx8UCxMuUI6z2rk=;
Message-ID: <815549.25363.qm@web31805.mail.mud.yahoo.com>
X-YMail-OSG: QmmqMVYVM1nvDNAso4Pse45AXIIk_ONvZaiXP6HKDsFKRqy
 AfHbFCKXeAwq2VFiZt3wqXkbZSedlL9oYDLzGB5cpqXz0WCszsNq3kWZ2BPl
 tVlkWsfy9a.Zpp2Oi7knSp.CItRRF2Jip38FCph5Oo85Qpx0d2Mv2GCDmb5C
 BSOQn5WoZ__oAUH0IQ3Wd.d6eT_vSvqj50QlfV.diRLtJw2tqmRpZ2LTFwOX
 qDTbp9ljLpn0AKwiYtkypnVkuzidcd7zxd2YdzsCiA8CGXATiADlJn_YDlxK
 GwagpKy4nTEB7KqBx3qjcvYsa6qHayLdc.mCPnewcx69eq6ENw6pw8MXWlrJ
 FeKdGFjKcxsZbYrvilj6_mw2O706UrvdbnlSgHVC5bfi2nA--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Thu, 2 Dec 2010 14:26:42 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
To: Greg KH <greg@kroah.com>, Matthew Wilcox <willy@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101202214011.GE5009@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 12/2/10, Matthew Wilcox <willy@linux.intel.com> wrote:
> > On Thu, Oct 28, 2010 at 01:05:14PM -0700, Luben Tuikov
> wrote:
> > > The reason to do this is to accommodate sending
> > > different IU types using the existing
> > > infrastructure.
> > > 
> > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > 
> > Matthew, it's been over a month, please comment on
> these UAS patches, or
> > I guess I'll just apply them...
> 
> Hi Greg,
> 
> These patches are NAKed in their current form.  Luben
> does not care for how
> I have modified them, so I need to rework them to take his
> name off them.
> I'll have a git tree ready for you after the weekend.

Are you serious? My commit message is quoted above. This email thread is available at http://marc.info/?t=128829652800022&r=1&w=2
as are my other patches to your code, where you stated you've committed them all but changed the commit logs (as typed by me). When asked to provide your changes to the commit logs in this very thread, you didn't. *Please don't twist the facts as you did my commit messages to suit your own needs.* 

