Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0FGMPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:15:08 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39631 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab0FGMPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:15:06 -0400
Message-ID: <4C0CE2C3.2030605@mev.co.uk>
Date: Mon, 7 Jun 2010 13:14:59 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100422 Thunderbird/3.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Support kernel/hotplug sysctl variable when !CONFIG_NET
References: <1275911832-11667-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1275911832-11667-1-git-send-email-abbotti@mev.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/10 12:57, Ian Abbott wrote:
> The kernel/hotplug sysctl variable (/proc/sys/kernel/hotplug file) was
      ^^^^^^^^^^^^^^

That should read "kernel.hotplug" of course!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
