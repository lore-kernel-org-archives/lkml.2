Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1K0MHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:07:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53158 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1K0MHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:07:13 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111127041642.GA16385@kroah.com>
References: <1322194447.30842.0.camel@phoenix> <20111127041642.GA16385@kroah.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 27 Nov 2011 20:01:07 +0800
Message-ID: <CAF+7xWm9g=H1cmZ2xeZTBTNd2o8zvAEyiNe+JREooQz2iKkZ1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] MISC: convert drivers/misc/* to use module_i2c_driver()
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anantha Narayanan <Anantha.Narayanan@intel.com>,
        Samu Onkalo <samu.p.onkalo@nokia.com>, Hemanth V <hemanthv@ti.com>,
        Christoph Mair <christoph.mair@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Gardner <bgardner@wabtec.com>, Minkyu Kang <mk7.kang@samsung.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Daniel Mack <zonque@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Anatolij Gustschin <agust@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/27 Greg KH <greg@kroah.com>:
> On Fri, Nov 25, 2011 at 12:14:07PM +0800, Axel Lin wrote:
>> This patch converts the drivers in drivers/misc/* to use the
>> module_i2c_driver() macro which makes the code smaller and a bit
>> simpler.
>
> Can you hang on to these patches until after 3.3-rc1 is out and the
> macros are in Linus's tree?  That way the cross-tree dependancy will not
> be there and all of the individual subsystem maintainers can apply
> things without having any problems.
Ok.
I didn't know that module_i2c_driver is not in Linus's tree when I
generated the patch against linux-next.
I'll resend the patch after module_i2c_driver is merged to Linus's tree.
Pls ignore this patch now.

Thanks,
Axel
