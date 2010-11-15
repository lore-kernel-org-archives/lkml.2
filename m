Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab0KOI3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:29:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:60998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623Ab0KOI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:29:04 -0500
Message-ID: <4CE0EF3F.3040707@kernel.org>
Date: Mon, 15 Nov 2010 09:28:47 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Joseph Chan <JosephChan@via.com.tw>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata-via: enable magic transmission fix for vt6420
References: <1289737911.24491.7.camel@twins>
In-Reply-To: <1289737911.24491.7.camel@twins>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 15 Nov 2010 08:28:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On 11/14/2010 01:31 PM, Peter Zijlstra wrote:
> I was able to reproduce and test the transmission error on vt6420
> hardware with the 2G WD drives. Adding the controller ID to this fix
> seems to result in a properly working system.

Yeah, there was another report on bugzilla and I contacted Joseph a
few days ago for confirmation.  There are multiple PCI IDs for vt6420
and I think we'll probably have to apply the workaround to all of
them.  Joseph, can you please confirm this?

Thanks.

-- 
tejun
