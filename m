Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1C3PCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:02:47 -0400
Received: from mail.perches.com ([173.55.12.10]:4423 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab1C3PCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:02:46 -0400
Subject: Re: [PATCH 00/23] drivers/platform/x86: Remove warnings and use
 pr_<level>
From: Joe Perches <joe@perches.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net,
        ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTik9KH_oU-u8gik12J7WEQTAm4tB+6R5kWFWikgx@mail.gmail.com>
References: <cover.1301436234.git.joe@perches.com>
	 <AANLkTik9KH_oU-u8gik12J7WEQTAm4tB+6R5kWFWikgx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 08:02:44 -0700
Message-ID: <1301497364.4113.34.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 14:30 +0000, Corentin Chary wrote:
> On Tue, Mar 29, 2011 at 10:21 PM, Joe Perches <joe@perches.com> wrote:
> > Removed a couple of compilation warnings.
> > Use pr_<level> consistently.
> Did you do that using coccinelle or by hand ?
> If you used coccinelle, is the .cocci file available ?
> If not, you should try it :).

Coccinelle is a fine tool, not appropriate for everything.

I used a newer version of a different script, posted a couple of times.
http://lwn.net/Articles/380161/

$ cvt_style.pl -o --convert=printk_to_pr_level drivers/platform/x86/*.c


