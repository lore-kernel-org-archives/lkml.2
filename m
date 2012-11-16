Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2KPSIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:08:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55501 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752069Ab2KPSIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:08:52 -0500
Message-ID: <1353089331.2512.2.camel@joe-AO722>
Subject: Re: [PATCH] ipack: move header files to include/linux
From: Joe Perches <joe@perches.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net, jens.taprogge@taprogge.org
Date: Fri, 16 Nov 2012 10:08:51 -0800
In-Reply-To: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
References: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 18:34 +0100, Samuel Iglesias Gonsalvez wrote:
> Move ipack header files to include/linux/ directory where they belong to.

Why do these belong in include/linux?
What's wrong with path relative includes?


