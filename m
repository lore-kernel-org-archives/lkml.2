Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0ERS2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:28:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41189 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0ERS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:28:03 -0400
Date: Tue, 18 May 2010 11:27:57 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/3] i7core_edac updates
Message-ID: <20100518182757.GY6511@lucy>
References: <20100518181001.GX6511@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100518181001.GX6511@lucy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-May-2010 11:10 AM, Vernon Mauery wrote:
>Three patches for i7core_edac
>
>In developing support for the Westmere processor with i7core_edac, I 
>also found two bugs.  Both are basically typos that were introduced 
>in earlier updates.  The third patch adds a table that keeps track of 
>the tables for pci ids that the i7core_edac driver supports.  This 
>makes it more convenient to add more devices later as Intel adds more 
>ids to the list of supported devices.
>

Okay, scratch that....  I didn't have things quite in order yet.  One 
patch was already applied and another had an alternate solution applied.  
So back to rebasing to the new head.  That's what you get for being a 
week behind the times, I guess.

--Vernon
