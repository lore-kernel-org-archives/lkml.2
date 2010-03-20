Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0CTWbt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 18:31:49 -0400
Received: from csmtp1.one.com ([195.47.247.21]:60395 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0CTWbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 18:31:48 -0400
Message-ID: <4BA54CD1.6060706@bitmath.org>
Date: Sat, 20 Mar 2010 23:31:45 +0100
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@enmesh.se>,
       linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: input: mt: Software finger tracking in the kernel?
References: <4BA358DB.20708@enmesh.se> <20100320194424.GC28402@core.coreip.homeip.net>
In-Reply-To: <20100320194424.GC28402@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> [...] I'd envisioned something more like a library providing common
> code that drivers could opt in to use, like we hane ff-memless for
> memory-less force-feedback devices.

As long as one can queue work with such a method, it looks like a good idea.

Henrik

