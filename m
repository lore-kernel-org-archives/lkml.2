Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0FOWdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 18:33:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64353 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0FOWdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 18:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Uk/OunZgHT/ZT3k92JizYlq9KPueFNfICStNoIepix7L/sdnxbXi/Q1SAtXMUntgb8
         uSbWHtbPpynzJEEo5l0vl73btEMPA0peCIvQ4SVzVWvtmNaZjNU0eGRaoNbh7ieHhqTA
         WXjNqL0AINPLi77zT22CE0bxQT3Y6NbOPhUIY=
MIME-Version: 1.0
In-Reply-To: <20100615065630.GC6727@basil.fritz.box>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com>
	<35525.41387.qm@web50105.mail.re2.yahoo.com>
	<20100615065630.GC6727@basil.fritz.box>
Date: Tue, 15 Jun 2010 15:33:51 -0700
X-Google-Sender-Auth: hPOZHgHw6SPpANb0WSrgipQ1Csw
Message-ID: <AANLkTikS9ocvQm2WK_9PFeiMNCcBGeW-8o1r30nnb59Y@mail.gmail.com>
Subject: Re: Hardware Error Kernel Mini-Summit
From: Tony Luck <tony.luck@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Doug Thompson <norsk5@yahoo.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nils Carlson <nils.carlson@ludd.ltu.se>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       BrentYoung <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:56 PM, Andi Kleen <andi@firstfloor.org> wrote:
> The way I envision it to working is that a abstracted dimm interface
> (or edac2 or whatever you want to call it) can be fed from any reasonable
> DIMM layout driver. This could be either DMI on x86 or some other
> driver. There would be nothing really x86 specific about that.

You could go one stage further and make DIMMs just one example of
a field replaceable unit.  So the "error analysis subsystem" would keep track
of errors reported by any component (cpu, DIMM, I/O card, fan, power
supply, disk, ...).  Each category could have different "X errors per Y
interval" parameter that made sense for it.

-Tony
