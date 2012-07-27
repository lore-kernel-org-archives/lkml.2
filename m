Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2G0Puc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:50:32 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50887 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2G0Pub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:50:31 -0400
Date: Fri, 27 Jul 2012 08:50:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: ccross@android.com, hmh@hmh.eng.br, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH 0/3] add new API to sysfs and device core code
Message-ID: <20120727155027.GA535@kroah.com>
References: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:02:40PM +0800, Bryan Wu wrote:
> Send out a uevent when create file in sysfs, which is required by userspace
> application such udev in Android

There is no such thing as "udev in Android" the last time I looked.

Has this changed?
