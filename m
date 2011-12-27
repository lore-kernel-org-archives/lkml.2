Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1L0Qnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 11:43:47 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:56902 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab1L0Qnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 11:43:45 -0500
MIME-Version: 1.0
In-Reply-To: <20111221182817.GA25036@srcf.ucam.org>
References: <CAGZ=bqKqO328BQa7+0S-GNfmvgKurcB1Z66qbCMT7Fu3G=7Leg@mail.gmail.com>
 <20111221182817.GA25036@srcf.ucam.org>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Tue, 27 Dec 2011 11:43:23 -0500
Message-ID: <CAGZ=bqKm55ThEq3_pDWemVAZJzfiU=4x=U2_4inoy-tZjDnxgg@mail.gmail.com>
Subject: Re: HP Envy 17 3D BIOS reports "Thermal Shutdown" on every reboot
 despite no thermal problems
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 13:28, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Try the patch I sent entitled "[PATCH] ACPI: Evaluate thermal trip
> points before reading temperature".

Perfect, thank you very much!

Tested-by: Kyle Moffett <kyle@moffetthome.net>

Any idea when it will get merged?

Cheers,
Kyle Moffett

-- 
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
