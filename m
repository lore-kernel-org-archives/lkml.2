Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0LUQke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:40:34 -0500
Received: from adelie.canonical.com ([91.189.90.139]:57771 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab0LUQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:40:33 -0500
Message-ID: <4D10D875.5040905@canonical.com>
Date: Tue, 21 Dec 2010 11:40:21 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: synaptics - ignore bogus mt packet
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se> <1292852364-19127-4-git-send-email-rydberg@euromail.se>
In-Reply-To: <1292852364-19127-4-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 08:39 AM, Henrik Rydberg wrote:
> In multitouch mode, at least one device (fw: 7.4 id: 0x1c0b1) sometimes
> sends a final main packet with x == 1. Since the normal values are above
> 1472, this is clearly bogus. At the same time, a two-finger touch is
> signaled, even though only one finger was on the pad to begin with. This
> patch ignores the packet altogether, removing the problem.
> 
> Acked-by: Chris Bagwell <chris@cnpbagwell.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Acked-by: Chase Douglas <chase.douglas@canonical.com>
