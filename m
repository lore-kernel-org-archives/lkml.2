Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724Ab2JWXTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:19:32 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:26344 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab2JWXTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:19:30 -0400
Message-ID: <508725FF.50108@synaptics.com>
Date: Tue, 23 Oct 2012 16:19:27 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com> <1349496603-20775-2-git-send-email-cheiny@synaptics.com> <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com> <BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local> <CACRpkdY3jctXSBB+SMJ=6k=CcLEsHz4jY8T3db8htcE+zWnJWw@mail.gmail.com> <20121016062603.GG8670@opensource.wolfsonmicro.com>
In-Reply-To: <20121016062603.GG8670@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 11:26 PM, Mark Brown wrote:
> On Thu, Oct 11, 2012 at 05:32:59PM +0200, Linus Walleij wrote:
>> On Thu, Oct 11, 2012 at 5:41 AM, Christopher Heiny <Cheiny@synaptics.com> wrote:
>
>>> In previous patch submissions, we always used these warning functions.
>>> But in the feedback on those patches, we were asked to just make
>>> sysfs show/store NULL if the attribute is write/read only.  However,
>>> during their development process, our customers want to see the
>>> warnings if the attributes are accessed incorrectly.  So we made
>>> these warnings a debug option.
>
>> Basically my stance is that you should not lower yourself to the
>> level of others not getting the point of your technical solution
>> by making unelegant compromises, what
>> you should do is to bring them up to your level so they
>> understand that your solution is elegant.
>
> It seems like what you really want to do is add a debug feature to sysfs
> which will optionally complain loudly at bad accesses; obviously it's
> not something that should be there all the time as running then handling
> an error is a perfectly legitimate thing to do.  As with the /CS
> handling it'd mean it was handled at an appropriate level and could be
> reused elsewhere (it might also help make it clear to your customers why
> this is generally bad form).

See my reply to Dmitry of a bit ago.  These are no longer needed, and 
we'll be dropping them.
