Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab0LPRoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:44:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59841 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0LPRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:44:14 -0500
Date: Thu, 16 Dec 2010 09:42:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [0/223] 2.6.35.10 longterm review
Message-Id: <20101216094218.85f8fb69.randy.dunlap@oracle.com>
In-Reply-To: <201012131244.547034648@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010 00:44:54 +0100 (CET) Andi Kleen wrote:

> 
> This is the start of the longterm review cycle for the 2.6.35.10 release.
> There are a large number of patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> Reponses should be made within 48 hours.

(oh well)


Future 2.6.35.* longterm could use this commit to fix a build error:

commit f35843ed8d17562f7c5da4b34a4a81b0cc450e9e
Author: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Date:   Wed May 26 12:00:10 2010 -0300
    classmate-laptop: depends on RFKILL or RFKILL=n

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
