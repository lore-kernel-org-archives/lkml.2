Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab0G2RPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 13:15:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59592 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758116Ab0G2RPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 13:15:43 -0400
Date: Thu, 29 Jul 2010 10:15:54 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dtor@mail.ru>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Nick Cheng <nick.cheng@areca.com.tw>,
        James Smart <james.smart@emulex.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/6] regulator: Remove owner field from attribute
 initialization in regulator core driver
Message-ID: <20100729171553.GA24781@opensource.wolfsonmicro.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
 <1280380166-29196-5-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280380166-29196-5-git-send-email-guenter.roeck@ericsson.com>
X-Cookie: You will be run over by a bus.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 10:09:24PM -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
