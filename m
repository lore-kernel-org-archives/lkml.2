Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0LNViy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:38:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39634 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0LNViw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:38:52 -0500
Message-ID: <4D07E3E4.50109@canonical.com>
Date: Tue, 14 Dec 2010 13:38:44 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
CC: Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
In-Reply-To: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 01:21 PM, Chase Douglas wrote:
> Hello all,
> 
> I was left somewhat dissatisfied by the MT_TOOL_ENVELOPE addition, so I decided
> to try to propose a different solution for the problem. As a recap, the problem
> can best be defined by Synaptics hardware that provide two touch coordinates
> (X1, Y1) and (X2, Y2). Unfortunately, the real touches may be at (X1, Y2) and
> (X2, Y1). Further, three touches may be recognized, but only two coordinates are
> reported.
> 
> Following this are four patches.

[...]

I forgot to mention that these apply on top of Dmitry's next tree plus
the first synaptics multitouch patch. My bad :(.

-- Chase
