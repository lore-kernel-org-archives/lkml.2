Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1KYKkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:40:00 -0500
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1081 "HELO
	smtp-out-169.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752655Ab1KYKj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:39:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26331
Message-ID: <4ECF70BB.2080904@metafoo.de>
Date: Fri, 25 Nov 2011 11:40:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anantha Narayanan <Anantha.Narayanan@intel.com>,
        Samu Onkalo <samu.p.onkalo@nokia.com>, Hemanth V <hemanthv@ti.com>,
        Christoph Mair <christoph.mair@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Gardner <bgardner@wabtec.com>, Minkyu Kang <mk7.kang@samsung.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Daniel Mack <zonque@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH 1/2] MISC: convert drivers/misc/* to use module_i2c_driver()
References: <1322194447.30842.0.camel@phoenix> <4ECF5213.20501@metafoo.de> <201111251015.43439.arnd@arndb.de>
In-Reply-To: <201111251015.43439.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 11:15 AM, Arnd Bergmann wrote:
> On Friday 25 November 2011, Lars-Peter Clausen wrote:
>> On 11/25/2011 05:14 AM, Axel Lin wrote:
>>> This patch converts the drivers in drivers/misc/* to use the
>>> module_i2c_driver() macro which makes the code smaller and a bit
>>> simpler.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
>> I think we should wait with spi and i2c patches until the macro can actually
>> be found in respective subsystem tree. Or do you want these patches to go
>> through GregKH's driver-core tree?
> 
> Obviously it can only go in after the patches introducing the macros.
> Since Greg owns both the char-misc and driver-core trees, there should
> be no problem coordinating between the two.
> 
Yes, but a similar patch has been send out for of a bunch of other trees.
And the commit message does not state that there is a dependency on not yet
applied patches and neither where to get them.
