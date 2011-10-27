Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1J0WQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:16:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab1J0WP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:15:59 -0400
Message-ID: <4EA9D819.9050400@redhat.com>
Date: Fri, 28 Oct 2011 00:15:53 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Ari Savolainen <ari.m.savolainen@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: lvm gets stuck during booting due to recent uevent change
References: <CAEbykaU_v6yYOVO3obyQDzacKrF5baOV6yXGZC010S1D=YKsbw@mail.gmail.com>
In-Reply-To: <CAEbykaU_v6yYOVO3obyQDzacKrF5baOV6yXGZC010S1D=YKsbw@mail.gmail.com>
X-Enigmail-Version: 1.2.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 11:59 PM, Ari Savolainen wrote:
> At the same time udevd is executing "/sbin/lvm vgchange -a y" (from
> /lib/udev/rules.d/85-lvm2.rules) that calls ioctl to resume a logical
> volume. After that lvm gets stuck forever. Booting continues after the
> 61 second timeout.

If you call vgchange or even vgscan from udev rule, it is completely wrong.

This is not lvm upstream udev rule btw.

Milan
