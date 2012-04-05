Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2DEGxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:53:10 -0400
Received: from csmtp3.one.com ([91.198.169.23]:23127 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab2DEGxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:53:08 -0400
Date: Thu, 5 Apr 2012 08:53:49 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCHv3 3/3] misc: add support for bmp18x chips to the bmp085
 driver
Message-ID: <20120405065349.GA7346@skinner.xfiles.lan>
References: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com>
 <1333568759-13536-4-git-send-email-eric.andersson@unixphere.com>
 <20120404195532.GB10787@opensource.wolfsonmicro.com>
 <201204042000.34160.arnd@arndb.de>
 <20120404201116.GC10787@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404201116.GC10787@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the review guys!

On 21:11 Wed 04 Apr     , Mark Brown wrote:
> On Wed, Apr 04, 2012 at 08:00:33PM +0000, Arnd Bergmann wrote:
> > On Wednesday 04 April 2012, Mark Brown wrote:
> > > > +static const struct of_device_id bmp085_of_match[] = {
> > > > +     { .compatible = "bosch-sensortec,bmp085", },
> 
> > > Traditionally the stock ticker symbol would be used.
> 
> > I though about commenting on that as well, but since Bosch is a foundation
> > and not publically traded, that would be hard to accomplish. Is there
> > an official fallback for companies that don't have a stock ticker symbol?
> 
> Guess we should ask the DT people...  I mostly just noticed that the
> name appeared somewhat verbose - perhaps just plain "bosch" if there's
> not a better abbrevation?

If there are no further objections let's go with "bosch". I'll prepare a
new patch-set ASAP.

-- 
Best regards,
 Eric

http://www.unixphere.com
