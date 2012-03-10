Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2CJQGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 11:06:16 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55818 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab2CJQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 11:06:13 -0500
X-Sasl-enc: hGvY/Nmg0XILroA+ic1IZKj7BJD+1nBSkz0rgsQRvDUR 1331395572
Date: Sat, 10 Mar 2012 13:06:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Manoj Iyer <manoj.iyer@canonical.com>,
        ibm-acpi-devel@lists.sourceforge.net, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: recognize Lenovo as
 version string in newer V-series BIOS
Message-ID: <20120310160609.GA6254@khazad-dum.debian.net>
References: <1331335944-4662-1-git-send-email-manoj.iyer@canonical.com>
 <1331335944-4662-2-git-send-email-manoj.iyer@canonical.com>
 <20120310042844.GA14972@khazad-dum.debian.net>
 <1331387907.2833.33.camel@scapa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331387907.2833.33.camel@scapa>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2012, Yves-Alexis Perez wrote:
> On sam., 2012-03-10 at 01:28 -0300, Henrique de Moraes Holschuh wrote:
> > So far so good, but what driver functionality works well in these new
> > lenovo boxes? 
> 
> V-series are Ideapad, so I'm not really sure this need to be added to
> thinkpad-acpi.

Yeah, it is not a thinkpad, not even in name.

However, it just might have enough of the thinkpad ACPI API to work,
thus my question.  What good does thinkpad-acpi do in a Lenovo Ideapad
V-series?   If it does something useful, we can support it (but it
likely needs more than just this patch to be safe).

If it doesn't do anything useful, consider this as an absolute NACK
(i.e. I will outright revert it if it lands).  Loading thinkpad-acpi on
a notebook that doesn't benefit from it is harmful in the long term, as
thinkpad-acpi can suddenly start calling weird stuff in ACPI on that box
and do something bad.   There is a real reason why we restrict IBM-era
stuff to IBM thinkpads, etc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
