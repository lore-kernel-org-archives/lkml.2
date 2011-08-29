Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1H2WBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab1H2WBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:01:38 -0400
Date: Mon, 29 Aug 2011 18:00:24 -0400
From: Dave Jones <davej@redhat.com>
To: Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: Jiri Kosina <trivial@kernel.org>, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] input: apanel: remove a redundant MODULE_ALIAS
Message-ID: <20110829220024.GA27009@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
	Jiri Kosina <trivial@kernel.org>, linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1314653189-31020-1-git-send-email-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1314653189-31020-1-git-send-email-j.neuschaefer@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:26:29PM +0200, Jonathan Neuschäfer wrote:
 
 > -MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
 >  MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
 
                                         ^
Is the module matching code case-insensitive ?

	Dave

