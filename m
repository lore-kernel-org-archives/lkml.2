Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0EaNLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:11:11 -0400
Received: from mailout-eu.gmx.com ([213.165.64.42]:37348 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754383Ab0EaNLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:11:08 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1+qjlMTTKyqbpSfBy+G+mokEeMuoPPwGU948XHjf2
	hOV7Dmp2QtQCL6
Subject: Re: iwl3945 bug in 2.6.34
From: Ivan Bulatovic <combuster@gmx.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Satish Eerpini <eerpini@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274830187.2091.17034.camel@rchatre-DESK>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
	 <1274726029.2091.15160.camel@rchatre-DESK>
	 <1274738896.2091.15438.camel@rchatre-DESK>
	 <1274830187.2091.17034.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 15:06:16 +0200
Message-ID: <1275311176.3329.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 16:29 -0700, reinette chatre wrote: 
> Hi Satish,
> 
> On Mon, 2010-05-24 at 15:08 -0700, reinette chatre wrote:
> > On Mon, 2010-05-24 at 11:33 -0700, reinette chatre wrote:
> > > On Sat, 2010-05-22 at 23:25 -0700, Satish Eerpini wrote:
> > > 
> > > > No probe response from AP 00:1b:da:2a:a1:53 after 500ms, disconnecting.
> > > > iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> > > > iwl3945 0000:10:00.0: Error setting new configuration (-110).
> > > > iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> > > > iwl3945 0000:10:00.0: Error setting new configuration (-110).
> > > 
> > > This did not use to be an issue with 3945 and unfortunately we do not
> > > know what is triggering it now. Please try the "Enable stuck queue
> > > detection on 3945" patch that is attached to
> > > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1834 as a
> > > workaround.
> > 
> > Actually, sorry, but that patch will not work on 2.6.34 since the
> > feature it enables is not present there - it will be in 2.6.35 though.
> > To enable the feature in 2.6.34 will take some more backporting effort
> > that I'm looking into now.
> 
> Please try the attached two patches.
> 
> Reinette
> 
I didn't have a problem with 2.6.34 but with 2.6.35-rc1 while obtaing IP
address with dhcpcd it bails out with reason 3 and gets timed out. I've
tried to increase timeout to 100 but the result is the same. I can't
apply this patches because base is somewhat different, as I can see the
first patch is already applied but the second one isn't. Any
suggestions ? Thanks. In the meantime I will try to get some more debug
information.

