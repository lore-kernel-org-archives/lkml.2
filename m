Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2GHBQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 21:16:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46118 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2GHBQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 21:16:27 -0400
Date: Sat, 7 Jul 2012 18:16:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Input: synaptics - add sysfs access to firmware
 ID & board ID
Message-ID: <20120708011621.GG19007@core.coreip.homeip.net>
References: <1341392837-19115-1-git-send-email-djkurtz@chromium.org>
 <1341392837-19115-2-git-send-email-djkurtz@chromium.org>
 <20120704130848.GA316@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120704130848.GA316@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 03:08:48PM +0200, Henrik Rydberg wrote:
> On Wed, Jul 04, 2012 at 05:07:17PM +0800, Daniel Kurtz wrote:
> > Allow userspace to query firmware ID and board ID, which are read and
> > cached during device initialization.
> > 
> > This information can be read, for instance, by a userspace feedback
> > reporting tool, to include this information in its reports.
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
> >  drivers/input/mouse/synaptics.c |   41 +++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 41 insertions(+), 0 deletions(-)
> 
> Still reluctant here, but I am fine with whatever Dmitry thinks about it.

I do not think we need to have additional attributes - reporting
tools will collect kernel logs so since your previous change dumps the
data there that is all we need.

Thanks.

-- 
Dmitry
