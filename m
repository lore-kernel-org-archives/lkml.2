Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab0ELWfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:35:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:36989 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758341Ab0ELWfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:35:07 -0400
Date: Wed, 12 May 2010 15:35:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: system locks up when CD burn fails
Message-ID: <alpine.DEB.2.01.1005121530090.8603@asgard.lang.hm>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a couple hundred boxes running kernels from 2.6.12 through 2.6.33.3 
that each burn a backup to a IDE CD-ROM once a week. Every couple of 
months one of the boxes (_not_ the same one each time) runs into some sort 
of error when burning the CD and the entire box locks up (unable to toggle 
numlock even). I have not been able to find any correlation between 
failures and anything on the system.

when the system locks up it doesn't log anything, and the screen just 
freezes in the middle of the cdrecord status (X of Y MB written) with no 
error message.

I'm actually not worried that much about the burn failing, The problem is 
that the burn failing will take out the entire system. Is there anything 
that I should be doing to make the systems more robust in the face of such 
failures?

David Lang
