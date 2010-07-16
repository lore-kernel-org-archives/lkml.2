Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab0GPRQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:16:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58754 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab0GPRQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:16:39 -0400
Subject: Re: [PATCH 3/5] v2 Change the mutex name in the memory_block struct
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C3F55FC.4050205@austin.ibm.com>
References: <4C3F53D1.3090001@austin.ibm.com>
	 <4C3F55FC.4050205@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 16 Jul 2010 10:16:35 -0700
Message-ID: <1279300595.9207.223.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 13:39 -0500, Nathan Fontenot wrote:
> 
> Change the name of the memory_block mutex since it is now used for
> more than just gating changes to the status of the memory sections
> covered by the memory sysfs directory.

Heh, sorry about the previous comments. :)

You should move this up to be the first in the series.

-- Dave

