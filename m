Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1F1XBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:01:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58617 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1F1XAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:00:52 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.136.221]
In-Reply-To: <BANLkTim+CemMz7A3J94e1UywCNd0r1SABQ@mail.gmail.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-8-git-send-email-ohad@wizery.com> <20110627222121.GD20865@ponder.secretlab.ca>
 <BANLkTikt08CDJiKNxGF2mKmOhyxHfv21_g@mail.gmail.com> <BANLkTim+CemMz7A3J94e1UywCNd0r1SABQ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Jun 2011 02:00:31 +0300
Message-ID: <BANLkTi=16XEpvhWEAoUt_s5F41czeq2DVQ@mail.gmail.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 1:51 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> It's not the device_for_each_child() that you're 'putting' back from
> here.  Its the original kref initialization when the device was
> created.

device_unregister() is already calling put_device(), doesn't that deal
with the original kref init for us ?
