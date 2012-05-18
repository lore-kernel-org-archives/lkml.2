Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab2ERWpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:45:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41338 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab2ERWpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120509140111.GD1794@sortiz-mobl>
References: <1334696962-3642-1-git-send-email-seth.heasley@intel.com> <20120509140111.GD1794@sortiz-mobl>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 May 2012 16:44:45 -0600
X-Google-Sender-Auth: 6ox_QjwkYsDItYZh_MVfxlC7Eqw
Message-ID: <CACxGe6tJry45w8_czwoXTA-Lo=uLO8HiuETWPebBQ0_z6cnASA@mail.gmail.com>
Subject: Re: [PATCH 3/3] lpc_sch: Add Intel Centerton Multifunction Device support
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Seth Heasley <seth.heasley@intel.com>, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 8:01 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Seth,
>
> On Tue, Apr 17, 2012 at 02:09:22PM -0700, Seth Heasley wrote:
>> This patch adds the Intel Centerton processor DeviceID for the Integrated Legacy Block.  The ILB provides GPIO, SMBus, and Watchdog functionality. The ILB DeviceID is defined in include/linux/pci_ids.h.
>>
> Patch applied to my for-next branch, after removing this chunk (That should be
> part of your watchdog driver submission):

Hi Samuel,

Have you applied the gpio patch also [patch 2/3]?  It also depends on
the pci device id, so it best go via your tree with the other two.

I'm dropping it from my tree.

g.
