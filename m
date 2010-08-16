Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab0HPMOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:14:55 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:47277 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0HPMOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:14:54 -0400
Message-ID: <4C692BBB.8090707@neli.hopto.org>
Date: Mon, 16 Aug 2010 14:14:51 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/9] RapidIO: Add the ingress port number into the RIO
 switch  data structure
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-4-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1281712686-31308-4-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> A switch ingress port number has to be saved for software assisted error
> recovery from the error-stopped state. Saving this information also allows
> to remove several register reads from the RIO enumeration process.

Why not keep using the swpinfo field, as you can extract it from there? 
And your code actually does this.

Also processor devices can have multiple ports (not only switches), it 
would be good to be ready for that use case.

Micha

