Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1KXH2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:28:44 -0500
Received: from smtp-out-168.synserver.de ([212.40.185.168]:1067 "HELO
	smtp-out-165.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750938Ab1KXH2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:28:42 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23377
Message-ID: <4ECDF260.5030907@metafoo.de>
Date: Thu, 24 Nov 2011 08:29:36 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Ben Dooks <ben-i2c@fluff.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/5] SPI: Add helper macro for spi_driver boilerplate
References: <1321434819-23678-1-git-send-email-lars@metafoo.de> <1321434819-23678-4-git-send-email-lars@metafoo.de> <CACxGe6tz0ppZj=a_e4rkgNxzhQ4MSCtXKXGk_dPov80QDU4MCg@mail.gmail.com> <20111124001342.GN19115@trinity.fluff.org>
In-Reply-To: <20111124001342.GN19115@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 01:13 AM, Ben Dooks wrote:
> On Wed, Nov 16, 2011 at 10:12:54AM -0700, Grant Likely wrote:
>> On Wed, Nov 16, 2011 at 2:13 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> This patch introduces the module_spi_driver macro which is a convenience macro
>>> for SPI driver modules similar to module_platform_driver. It is intended to be
>>> used by drivers which init/exit section does nothing but register/unregister
>>> the SPI driver. By using this macro it is possible to eliminate a few lines of
>>> boilerplate code per SPI driver.
>>>
>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> I'm begining to think we need to make some of these driver and device
> bits more generic... there seems to be so much similar but not quite
> the same code.
> 

I've been thinking the same. A good start would probably be consolidating
the platform/spi/i2c device id handling code. Since those are all name based
ids the code for handling them looks rather similar, though there are some
minor differences.

- Lars
