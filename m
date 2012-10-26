Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193Ab2JZWq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 18:46:56 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48265 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2JZWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 18:46:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210270006130.2756@ionos>
References: <alpine.LFD.2.02.1210262036270.2756@ionos>
	<alpine.LFD.2.02.1210270006130.2756@ionos>
Date: Sat, 27 Oct 2012 01:46:54 +0300
Message-ID: <CAJL_dMvBKu_6-4HXL3YR-UeJ6CeHJadL26fvhO8wjw6OdA9wxw@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.6.3-rt7
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 1:08 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Looks like CONFIG_NUMA=y exposes explosions. I just noticed that none
> of the machines which are in my basic set of test systems have that
> enabled.
>
> /me goes to do some homework

Try https://github.com/torvalds/linux/commit/6b187d0260b6cd1d0904309f32659b7ed5948af8

(mm, numa: avoid setting zone_reclaim_mode unless a node is
sufficiently distant)
