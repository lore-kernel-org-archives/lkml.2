Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1CJUut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:50:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1CJUur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:50:47 -0500
Date: Thu, 10 Mar 2011 15:50:09 -0500
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] cpufreq: Remove the pm_message_t argument from driver
 suspend
Message-ID: <20110310205008.GB7750@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
References: <201103102113.05946.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103102113.05946.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 09:13:05PM +0100, Rafael J. Wysocki wrote:
 > From: Rafael J. Wysocki <rjw@sisk.pl>
 > 
 > None of the existing cpufreq drivers uses the second argument of
 > its .suspend() callback (which isn't useful anyway), so remove it.
 > 
 > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
 > ---
 > 
 > Hi,
 > 
 > This patch is requisite for sysdevs rework discussed here:
 > https://lkml.org/lkml/2011/3/9/439
 > Please apply or let me know if I can take it to the suspend tree.

Looks ok to me.

applied and queued for .39

thanks,

	Dave
