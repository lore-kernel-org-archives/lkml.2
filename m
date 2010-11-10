Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0KJSq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:46:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62123 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab0KJSq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:46:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=C6Ubhon+sp9dze07jcDjRGR9mBSR6gYEHHaNNOciXNXCQlbbyJSPnemqehFUNI27Ob
         FWAk3cgf4SEFo0W3XFkmyWz3cxQd9lZucYiH25a3n9G5sVbnlTb2MMWprI2ut1pjIeFD
         jbVZexTNLnxobXMhZYGb5fxgw6C6i1oqn1XQw=
MIME-Version: 1.0
In-Reply-To: <B7132A25476D334D9130FE7532F2A56314B58158FF@SC1EXMB-MBCL.global.atheros.com>
References: <1286349552.6145.11.camel@aeonflux> <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>
 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
 <20101006173949.GG7070@tux> <1286387660.3655.382.camel@jlt3.sipsolutions.net>
 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>
 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>
 <1286389697.3655.401.camel@jlt3.sipsolutions.net> <20101006183340.GI7070@tux>
 <44EE5C37ADC36343B0625A05DD408C4850DAD2CA31@CHEXMB-01.global.atheros.com>
 <1286465072.6145.151.camel@aeonflux> <4CADF6BF.6070305@atheros.com>
 <1286469741.6145.165.camel@aeonflux> <B7132A25476D334D9130FE7532F2A56314B58158FF@SC1EXMB-MBCL.global.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Nov 2010 10:46:06 -0800
Message-ID: <AANLkTikiST6OxNj2TN951s5Mh45ypgVi0bo=g0Hhkmaq@mail.gmail.com>
Subject: Re: RFC: btusb firmware load help
To: Kevin Hayes <kevin@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Helen Chu <Helen.Chu@atheros.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
        Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sree Durbha <Sree.Durbha@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 6:38 AM, Kevin Hayes <kevin@atheros.com> wrote:
> Yes, it is a good idea to let the downloadable firmware set a new PID, along with the
>  blacklist on the 3002 PID for the first go round.  I emphasize, it is the downloaded
> firmware that will be required to do the PID swizzling, not the sflash firmware.  And I
> agree we should have a map of the PIDs in use and what they are used for, once
> we get through this immediate fixing phase.

FWIW, since we actually have customers already using this I took
Bala's original patch and put it into compat-wirelesss-2.6.36 and the
current bleeding edge compat-wireless so we can get customers at least
something working in the mean time. Of course this means we'll need to
support this patch should any issues come up ;).

The proper patch didn't make it to 2.6.37, hoping this will get
resolved for 2.6.38.

  Luis
