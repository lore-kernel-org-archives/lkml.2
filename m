Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0HWTld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:41:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HWTlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:41:32 -0400
Message-ID: <4C72CEE4.7020104@vlnb.net>
Date: Mon, 23 Aug 2010 23:41:24 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Bart Van Assche <bvanassche@acm.org>,
        Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org,
        Chetan Loke <chetanloke@gmail.com>,
        Chetan Loke <generationgnu@yahoo.com>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>	 <1282144271.3035.31.camel@mulgrave.site>	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>	 <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com> <1282508953.3042.102.camel@mulgrave.site>
In-Reply-To: <1282508953.3042.102.camel@mulgrave.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:SmDURXAUN/4IDaBEoy77cRRLZDB71c1GThx8xpga8R3
 vq0p2JlukR1eBsrd6QekjIlbv8uCakbDP9ejrc/tCtIEZiI/gS
 y37Wh5Kscj0PF4LI+MW8Cm2+648+nHorJ+g2Y/YN647NIj0QF+
 4ZRM8/0Wa82MmOfJIj61dn2FSHCK8KlKGLkUSKm8kQTOgt9Xtp
 gcy5mFY/r63EmhU8/QJ5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley, on 08/23/2010 12:29 AM wrote:
> So the phrase "up to GigE" was deliberately in the above to exclude the
> disputed infiniband results.  I'm not really interested in re-opening
> the arguments over how to interpret those results.  The fact that SCST
> and STGT were on par up to 1GbE is enough to refute the contention that
> STGT is "fundamentally slow".

Well, James, why not 100MbE? If you want a comparison of target 
implementations you need a fast hardware with minimal latency. 
Otherwise, the difference between the implementations can drown in the 
overhead of the accompanying processing. 1GbE is a nearly 10 years ago 
interface. Or are we going to stay ten years behind progress?

Thanks,
Vlad
