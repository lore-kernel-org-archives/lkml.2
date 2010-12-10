Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0LJRlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:41:16 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:45402 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab0LJRlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:41:14 -0500
Message-ID: <4D026634.4000602@euromail.se>
Date: Fri, 10 Dec 2010 18:41:08 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se> <20101210173611.GA1630@core.coreip.homeip.net>
In-Reply-To: <20101210173611.GA1630@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PR6xx-0006mt-AD.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PR6xx-0006mt-AD b1e73801cbdfee9db6a918fadab62f67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 06:36 PM, Dmitry Torokhov wrote:

> On Fri, Dec 10, 2010 at 06:24:02PM +0100, Henrik Rydberg wrote:
>> +#define MT_TOOL_ENVELOPE	2	/* rectangle corner - legacy use only */
> 
> Legacy to me implies we can upgrade, but this is hardware limitation.
> Can we say "rectangle corner - used by older hardware"?
> 


How about "- older hw only", to stay within a single line?

Henrik
