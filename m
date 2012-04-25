Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab2DYLbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:31:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64655 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab2DYLbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120425072931.20124.56635.stgit@notabene.brown>
References: <20120425072931.20124.56635.stgit@notabene.brown>
Date: Wed, 25 Apr 2012 14:31:13 +0300
Message-ID: <CANOLnOOQDxu-P=yTN6159XJANq-_FSCtZ4rBt69NSCPjLz1Rjw@mail.gmail.com>
Subject: Re: [PATCH 0/6] twl4030: Various fixes for charing-from-USB
From: Grazvydas Ignotas <notasas@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:33 AM, NeilBrown <neilb@suse.de> wrote:
> Following are a collection of patches that I've need using for a while
> to make sure the charge-from-usb on my GTA04 works.
> Hopefully I've included the right people in the recipient list :-)

You missed the power supply maintainers - ./scripts/get_maintainer.pl
is usually good at finding the right people, although their
MAINTAINERS entry could be better I guess..


-- 
Gražvydas
