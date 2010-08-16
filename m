Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0HPMa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:30:58 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:42911 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0HPMa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:30:57 -0400
Message-ID: <4C692F7E.1060208@neli.hopto.org>
Date: Mon, 16 Aug 2010 14:30:54 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH 0/9] RapidIO: Set of patches to add Gen2 switches
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> This set of RapidIO patches adds support for new IDT Gen2 sRIO switch
> devices - CPS-1848 and CPS-1616.
> Adding these sRIO switches required to implement standard error recovery
> mechanism defined by the RapidIO specification.

This is not 'Gen2' specific, as these error management extensions also 
exist in v1.2/1.3 (?) of the specification? E.g. tsi56x and tsi57x could 
support this functionality?

Micha
