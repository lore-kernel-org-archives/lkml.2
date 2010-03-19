Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0CSKSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 06:18:36 -0400
Received: from poutre.nerim.net ([62.4.16.124]:63020 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab0CSKSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 06:18:35 -0400
Date: Fri, 19 Mar 2010 11:18:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Add basic support for LM64 to lm63.c
Message-ID: <20100319111831.3a21c245@hyperion.delvare>
In-Reply-To: <1268919419-2125-1-git-send-email-mjg@redhat.com>
References: <20100318084135.15fb1996@hyperion.delvare>
	<1268919419-2125-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 09:36:59 -0400, Matthew Garrett wrote:
> The LM64 appears to be an LM63 with added GPIO lines. Add support for the
> hwmon functionality - GPIO can be added at some later stage if someone
> has a need for them.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
> 
> Capitalisation fixes and remove an unused variable.

Applied, thanks!

-- 
Jean Delvare
