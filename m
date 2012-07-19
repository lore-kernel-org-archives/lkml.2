Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2GSSh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:37:27 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab2GSShS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:37:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carsten Emde <C.Emde@osadl.org>
Subject: Re: [PATCH 1/1 v3] Honor state disabling in the cpuidle ladder governor - with sanitizer
Date: Thu, 19 Jul 2012 20:42:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <20120717185914.063547728@osadl.org> <5007EC10.1060508@linux.vnet.ibm.com> <5007F1F3.9090706@osadl.org>
In-Reply-To: <5007F1F3.9090706@osadl.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207192042.57935.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, July 19, 2012, Carsten Emde wrote:
> Deepthi,
> 
> >>> [..]
> >>>> I could implement a sanitize mechanism of the ladder governor that
> >>>> takes care the "disable" variables of all deeper states are set to 1,
> >>>> if a state is disabled, and those of all lighter states are set to 0,
> >>>> if a state is enabled. Do you wish me to do that?
> >>> No, I dont think thats necessary, current code suffices it.
> >>> The disable flag is knob we are giving to the user . So may be just
> >>> document  the  intended use of disable flag working
> >>> alongside design of ladder governor.
> >> It's not necessary - but maybe better. Here comes v3 with a sanitizer.
> >> Is this too ugly?
> > The v2, with the documentation in place seems sufficient.
> > Yup, this adds unnecessary fields which are not much use
> > coz the same can be achieved with just disable flag check.
> ok, let's take v2.
> 
> > Also, any reason why the patch is being sent as an attachment ?
> > Sending patches as an attachment is not a recommended practice.
> Sorry.

Can you please resend the version regarded as the current one?

And please send it inline this time.

Thanks,
Rafael
