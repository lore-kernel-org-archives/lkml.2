Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab1AYAId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:08:33 -0500
Received: from 219-85-210-85-adsl-TPE.dynamic.so-net.net.tw ([219.85.210.85]:49733
	"EHLO darkstar.wytron.com.tw" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751344Ab1AYAIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:08:32 -0500
X-Greylist: delayed 33464 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jan 2011 19:08:31 EST
Message-ID: <4D3D91D1.8000701@wytron.com.tw>
Date: Mon, 24 Jan 2011 22:50:57 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: Grant Likely <grant.likely@secretlab.ca>, nios2-dev@sopc.et.ntust.edu.tw,
        David Brownell <dbrownell@users.sourceforge.net>,
        Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v2] spi: add OpenCores tiny SPI driver
References: <1294800109-31603-1-git-send-email-thomas@wytron.com.tw>	 <1295249542-26743-1-git-send-email-thomas@wytron.com.tw>	 <20110120165430.GA24445@angua.secretlab.ca>	 <4D38AAEB.7020308@wytron.com.tw> <1295612849.23825.26.camel@needafix>	 <4D3CD38D.4080808@wytron.com.tw> <1295866794.23825.100.camel@needafix>
In-Reply-To: <1295866794.23825.100.camel@needafix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

On 01/24/2011 06:59 PM, Jonas Bonn wrote:
> We've discussed this a bit internally now and decided that the best way
> to version OpenCores cores is to use the SVN commit ID of the rtl/
> directory in the project's repository.  So, for your tiny-spi project,
> the last SVN commit to update the rtl/ directory was commit number 2;
> hence, I'd recommend you use the following device tree identifier:
>
> opencores,tiny-spi-rtlsvn2
>
> That's:  opencores,<project>-rtl<VCS><commit ID>
>
> As projects are currently in SVN, VCS=svn.
>
> Linux drivers for other OpenCores cores will be updated accordingly.

I will follow your suggestion exactly. Thank you very much.

Best regards,
Thomas
